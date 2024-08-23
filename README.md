# SaleSmart
## Introduction 
**SaleSmart** is an all-in-one business management system designed specifically for small and medium-sized enterprises (SMEs). These businesses often face challenges in managing their day-to-day operations due to the manual nature of their processes. "SaleStream" aims to alleviate these pain points by offering a streamlined, automated solution that enhances efficiency, reduces errors, and allows business owners to focus on growth and customer satisfaction.

## Project Overview
Small and medium-sized enterprises (SMEs) frequently encounter difficulties such as inefficiencies, inaccuracies, and time-consuming processes when managing their daily operations manually. "SaleStream" addresses these challenges by providing a comprehensive solution that automates key aspects of business management, including inventory control, sales tracking, and financial reporting. The goal of this project is to significantly improve operational efficiency, minimize errors, and empower business owners to dedicate more time to scaling their business and serving their customers.

## ARCHITECTURE
### This project is built with a 3- tier architecture;
- ### Client desktop application
    The client-side application is built using Flutter, chosen for its cross-platform compatibility, which ensures that **SaleSmart** is accessible across various devices. This versatility is crucial for SMEs, which may have diverse hardware and software environments. Flutter's rich UI components also allow for the creation of an intuitive and responsive user interface.


- ### Application programming interface (API)
    The API is developed using Flask with a modular monolithic architecture. This architecture separates core functionalities—such as inventory management, sales analytics, and transactions and payments—into distinct modules. This modular approach facilitates easier development, testing, and future scaling of the system, ensuring that the API can grow with the business.

- ### Email API 
    The Email API is a custom-built solution designed to handle requests from the Flask API and send verification emails to users during registration. Built with Node.js, it leverages the Nodemailer package for seamless integration with Brevo's email service. Node.js was selected for its event-driven architecture, which is ideal for handling asynchronous tasks like email notifications efficiently.
    Find code in the directory BUSINESSMANAGER/email.
     or use command **cd BUSINESSMANAGER/email**.
     To server the email api use command **node email_server.js**

- ### Database 
   The system utilizes a PostgreSQL database, chosen for its robustness and ability to handle the complex, relational data structures associated with business operations. PostgreSQL's scalability and reliability make it an ideal choice for managing large volumes of transactional data and supporting the future growth of the **SaleSmart** system. 
      