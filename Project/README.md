# Package Delivery Company
The application is a package delivery company (similar to FedEx, UPS, DHL, the USPS, etc.). The company needs to keep track of packages shipped and their customers. To find out more about this application, think about any experiences you may have had shipping packages and receiving packages, and browse shippers’ web sites. In our hypothetical company, the manager assigned to solicit database design proposals is not very computer literate and is unable to provide a very detailed specification.

## Diagrams
<b>E-R (Entity-Relationship) - Diagram</b>
<p align="center">
  <img src="https://github.com/Assylzhan-Izbassar/Databases/blob/main/Project/final_version_of_relational_model.png" width="720" title="ER(Entity Relationship) - Diagram">
</p>
<p> <b>Description of ERD:</b></br>
● 1-1, 1-N and N-N lines depicts One-to-One, One-to-Many and Many-to-Many respectively.</br>
● Green Color Rectangles are Entities and Double Walled Rectangles are Weak Entities.</br>
</p>

## Building Relatial Model
<p>
  -- In the project ddl file <a href="https://github.com/Assylzhan-Izbassar/Databases/blob/main/Project/project_ddl.sql">project_ddl.sql</a>, we can see the data definition part of our project. That is the relational model created by PostgreSQL database. </br>
  -- In filling data file <a href="https://github.com/Assylzhan-Izbassar/Databases/blob/main/Project/filling_data.sql">filling_data.sql</a>, we can look at random data that generated with procedures. With the written procedures we can create counted data immediately, although it will be random. </br>
</p>

## Queries

<p>
  -- The queries for this project is represented in <a href="https://github.com/Assylzhan-Izbassar/Databases/blob/main/Project/queries.sql">queries.sql</a> file. Their the queries of </br>
  * Find all customers who had a package on that truck at the time of the crash, find all recipients who had a package on that truck at the time of the crash and etc.
</p>
