# FixMyCar (In Development)

FixMyCar is a project developed as part of the seminar work for the Software Development II course. It aims to streamline communication and operations between car repair shops, car parts shops, and clients. The project utilizes ASP.NET Core Web API for the backend and Flutter for the frontend.

## Features

- **Desktop Applications:** Designed for car repair shops and car parts shops, providing functionalities tailored to their needs.
- **Mobile Application:** Catered for clients, allowing them to interact with repair shops and parts shops conveniently.
- **Connectivity:** Seamlessly connects all three groups of users, facilitating communication and transactions.

## Technologies Used

- **Backend:** ASP.NET Core Web API
- **Frontend:** Flutter
- **Database:** SQL database - migrated using Entity Framework

## Getting Started

To get started with the project, follow the instructions below.

### Clone the Repository
 
    git clone https://github.com/EsrefPivcic/FixMyCar.git

### Set Up the Backend

#### Navigate to the Solution Folder:

Go to the `FixMyCar` folder and open the `FixMyCar.sln` file (Visual Studio 2022 recommended).

#### Rebuild the Solution:

Right-click on the solution and select `Rebuild Solution` to restore all NuGet packages.

#### Configure JWT Settings:

In the Solution Explorer, under `FixMyCar.API`, open the `appsettings.json` file.

In the `"JwtSettings"` section, under the `"Secret"` field, insert a JWT secret key. You can use the following key for testing purposes:

    XQ3Qk+htrTPgxNwAARlWNV7Bl5DHzuk5NcxQbWXuP1A=

Alternatively, generate your own key using this C# script:

    using System.Security.Cryptography;

    int size = 32;
    var key = new byte[size];
    using (var generator = RandomNumberGenerator.Create())
    {
        generator.GetBytes(key);
    }
    Console.WriteLine("Key: " + Convert.ToBase64String(key));

#### Database Setup:

Open the Package Manager Console and ensure the default project is set to `FixMyCar.Services`. Run the following commands to create and seed the database:

    add-migration initialMigration -o Database/Migrations
    update-database

#### Run the API:

Start the API by running the solution.

### Set Up the Frontend

#### Navigate to the UI Folder:

In the solution folder (`FixMyCar`), navigate to `FixMyCar.UI/fixmycar_car_parts_shop`, `FixMyCar.UI/fixmycar_car_repair_shop` or `FixMyCar.UI/fixmycar_admin`. Those are the Windows apps for car parts shops, car repair shops and admins (client side android app will be added soon).

#### Open the folder with Visual Studio Code:

    code .

#### Install Dependencies:

In the terminal, run the following command to get all dependencies:

    flutter pub get

#### Run the App:

To start the app, run:

    flutter run -d windows

### Test the App

Use the following credentials to test the car parts shop app:

- Username: carpartsshop
- Password: carpartsshop

Use the following credentials to test the car repair shop app:

- Username: carrepairshop
- Password: carrepairshop

Use the following credentials to test the admin app:

- Username: admin
- Password: admin

Feel free to explore and test the current features of the app.

## License

This project is licensed under the [MIT License](LICENSE).
