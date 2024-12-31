CREATE TABLE parents AS
  SELECT "ace" AS parent, "bella" AS child UNION
  SELECT "ace"          , "charlie"        UNION
  SELECT "daisy"        , "hank"           UNION
  SELECT "finn"         , "ace"            UNION
  SELECT "finn"         , "daisy"          UNION
  SELECT "finn"         , "ginger"         UNION
  SELECT "ellie"        , "finn";

CREATE TABLE dogs AS
  SELECT "ace" AS name, "long" AS fur, 26 AS height UNION
  SELECT "bella"      , "short"      , 52           UNION
  SELECT "charlie"    , "long"       , 47           UNION
  SELECT "daisy"      , "long"       , 46           UNION
  SELECT "ellie"      , "short"      , 35           UNION
  SELECT "finn"       , "curly"      , 32           UNION
  SELECT "ginger"     , "short"      , 28           UNION
  SELECT "hank"       , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  select child from parents join dogs on parents.parent = dogs.name order by height desc;


-- The size of each dog
CREATE TABLE size_of_dogs AS
  select name, size from dogs join sizes on dogs.height > sizes.min and dogs.height <= sizes.max;


-- [Optional] Filling out this helper table is recommended
CREATE TABLE siblings AS
  SELECT DISTINCT 
    CASE WHEN a.child < b.child THEN a.child ELSE b.child END AS sibling1,
    CASE WHEN a.child < b.child THEN b.child ELSE a.child END AS sibling2,
    a.parent
  FROM parents AS a, parents AS b
  WHERE a.parent = b.parent AND a.child < b.child;
  

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT 
    "The two siblings, " || s.sibling1 || " and " || s.sibling2 || 
    ", have the same size: " || d1.size
  FROM siblings AS s, size_of_dogs AS d1, size_of_dogs AS d2
  WHERE s.sibling1 = d1.name 
    AND s.sibling2 = d2.name 
    AND d1.size = d2.size
  ORDER BY d1.size DESC;
  


-- Height range for each fur type where all of the heights differ by no more than 30% from the average height
CREATE TABLE low_variance AS
  WITH avg_heights AS (
    SELECT fur, AVG(height) as avg_height
    FROM dogs
    GROUP BY fur
  ),
  valid_furs AS (
    SELECT DISTINCT d.fur
    FROM dogs d
    JOIN avg_heights a ON d.fur = a.fur
    GROUP BY d.fur
    HAVING MAX(d.height) <= 1.3 * AVG(d.height)
      AND MIN(d.height) >= 0.7 * AVG(d.height)
  )
  SELECT d.fur, MAX(d.height) - MIN(d.height) as range
  FROM dogs d
  JOIN valid_furs v ON d.fur = v.fur
  GROUP BY d.fur;

