# PacificKode mini job listing app
A Flutter project to show job listings and allow users to submit applications

## Architecture
This project follows the **Clean Architecture** pattern, with a structured separation of concerns:
- **data**: Contains all API-related logic and services.
- **domain**: Includes all the data models used throughout the app.
- **presentation**: Contains UI and state management using the `provider` package.
- **core**: Includes all the common widgets, themes, and services used throughout the app.

## State Management
This app uses the **Provider** package for state management.  
It cleanly separates UI components from business logic by using a `JobProvider` class, which handles all interactions between the API layer and the UI.  
A `ThemeProvider` is also used to manage and toggle light/dark themes across the app.
This approach ensures better maintainability, testability, and scalability of the app.

## Features
1: View available jobs.
2: Apply for jobs
3: Save favourites locally using Hive.

4: Search jobs
5: Nice page transitions

## Getting Started
1: Clone this repo below
https://github.com/MohamedRiham/pacific_kode_practical
2: Get dependencies
3: Run the app

