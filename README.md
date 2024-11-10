# FixMyCar

**FixMyCar** is a comprehensive software solution developed as part of a seminar project for the Software Development II course. The platform enhances communication and operations between car repair shops, car parts shops, and clients by providing seamless interaction across all parties. The system is built with an **ASP.NET Core Web API** backend and a **Flutter** frontend.

## Features

- **Desktop Applications**: Tailored for car repair shops, car parts shops, and system administrators, offering essential tools to manage their services effectively.
- **Mobile Application**: Designed for clients, enabling convenient interaction with both car repair and parts shops.
- **Integrated Platform**: The system unifies all three user groups, streamlining communication, service requests, and transactions.

## Technologies Used

- **Backend**: ASP.NET Core Web API with Entity Framework, both the API and the SQL database are containerized using Docker.
- **Frontend**: Flutter (for both desktop and mobile applications).

## Getting Started

Follow the steps below to set up and run the project.

### Prerequisites

Ensure you have the following tools installed:
- **Docker**: For containerizing the backend.
- **Visual Studio Code**: Recommended for editing and running the frontend (Flutter).
- **Flutter**: To run the desktop and mobile applications.

### Clone the Repository

```bash
git clone https://github.com/EsrefPivcic/FixMyCar
```

### Environment variables:

The following environment variables are required:

- **Backend:** ```JWT_SECRET_KEY```, ```STRIPE_PUBLISHABLE_KEY``` and ```STRIPE_SECRET_KEY```
- **Frontend (mobile app):** ```STRIPE_PUBLISHABLE_KEY```

You can define these variables by either:

1. Creating a ```.env``` file in:

- **Backend:** ```FixMyCar/FixMyCar.```
- **Mobile App:** ```FixMyCar/FixMyCar/FixMyCar.UI/fixmycar_client/lib/src/assets```

2. Configuring them in the command prompt or PowerShell:

- **For command prompt:**

```bash
set STRIPE_SECRET_KEY=stripeSecretKey
```

- **For PowerShell:**

```bash
$env:STRIPE_SECRET_KEY = "stripeSecretKey"
```

### Running the Backend API:

To start the API and other necessary services, navigate to the project's root folder (```FixMyCar/FixMyCar```) and run the following command:

```bash
docker-compose up --build
```

### Running the Desktop Apps:

The desktop applications are designed for the car parts shop, car repair shop, and system administrator roles. To run them:

1. Navigate to the appropriate folder based on role:

- ```FixMyCar.UI/fixmycar_car_parts_shop``` for car parts shops.
- ```FixMyCar.UI/fixmycar_car_repair_shop``` for car repair shops.
- ```FixMyCar.UI/fixmycar_admin``` for the system administrator.

2. Install the necessary dependencies:

```bash
flutter pub get
```

3. Run the application:

```bash
flutter run -d windows
```

### Running the Mobile App:

1. Navigate to the mobile app folder: ```FixMyCar.UI/fixmycar_client```.

2. Install dependencies:

```bash
flutter pub get
```

3. If you have the .env file set up, simply run:

```bash
flutter run
```

4. If you don’t have an .env file, you can pass the Stripe key directly:

```bash
flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=yourStripePublishableKey
```

5. To run the app on a physical device, ensure you provide the API host address:

```bash
flutter run --dart-define=API_HOST=xxx.xxx.xxx.xxx
```

### Credentials For Testing

#### Administrator App

- Username: admin
- Password: test

#### Car Parts Shop App

- Username: carpartsshop
- Password: test

#### Car Repair Shop App

- Username: carrepairshop
- Password: test

#### Client App

- Username: client
- Password: test

Additionally, there are several test accounts available (e.g., carpartsshop2, carrepairshop2, client2), all using the password ```test```.

#### Testing Payments

To test payment processing, use the following details:

- Card Number: ```4242 4242 4242 4242```
- Expiration Date: ```Any future date```
- CVC: ```Any three-digit number```

## License

This project is licensed under the [MIT License](LICENSE).
