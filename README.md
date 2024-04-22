# Unlimited Talk

This project implements a robust chat system designed to support real-time messaging across various applications. Each application registered in the system can have multiple chats, and each chat can contain numerous messages.

## Features

- **Application Management**: Users can create applications, each identified by a unique token.
- **Chat Functionality**: Each application can host numerous chats, with chats uniquely numbered within their respective applications.
- **Message Handling**: Chats support the addition of messages, which are also uniquely numbered within their respective chats.
- **Search Capability**: Includes the ability to search through messages within a chat based on partial text matching, utilizing Elasticsearch for efficient search operations.
- **Count Tracking**: Tracks the number of chats and messages within each application and chat, respectively, updated with minimal lag.
- **Concurrency and Scalability**: Designed to handle multiple requests concurrently without direct database writes during request processing, using queues to manage data flow.
- **Containerization**: Fully containerized with Docker, allowing for easy setup and deployment using Docker Compose.

## Prerequisites

Before you begin, ensure you have met the following requirements:
* You have installed Docker and Docker Compose.

## Setup

To install **Unlimited Talk**, follow these steps:

```bash
git clone https://github.com/Ahmed-Abdelhafez98/Unlimited-Talk.git
cd Unlimited-Talk
sh ./install.sh
```

## Check Endpoints

Here is a [postman collection](https://api.postman.com/collections/16343939-47b912ef-acaf-4949-807f-571b30e7c9af?access_key=PMAT-01HW26EBHGMCZBGXS3K30819SJ) 
you will find all the app endpoints inside it
## Usage

Here's a brief intro about how to use **Project Name**:

1. Start the server:
```bash
docker-compose up
```


2. Access the application at `http://localhost:3000`.

3. To stop the application:
```bash
docker-compose down
```


## Running Tests

To run tests, use the following command:
```bash
docker-compose exec app bundle exec rspec
```

## Contributing to Unlimited Talk

To contribute to **Unlimited Talk**, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin Unlimited-Talk/<location>`
5. Create the pull request.


## Contact

If you want to contact me you can reach me at <ahmed.emad.abdelhafez@gmail.com>.