psql --username=freecodecamp --dbname=periodic_table
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;
ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;
ALTER TABLE elements ADD UNIQUE (symbol, name);
ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements (atomic_number);
CREATE TABLE types (
    type_id INTEGER PRIMARY KEY,
    type VARCHAR NOT NULL
);
INSERT INTO types (type_id, type) VALUES (1, 'nonmetal'), (2, 'metal'), (3, 'metalloid');
ALTER TABLE properties ADD COLUMN type_id INTEGER;
ALTER TABLE properties ADD FOREIGN KEY (type_id) REFERENCES types (type_id);
