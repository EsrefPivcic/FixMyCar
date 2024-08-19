﻿using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FixMyCar.Services.Database.Migartions
{
    public partial class migration : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CarManufacturers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CarManufacturers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ServiceTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Image = table.Column<byte[]>(type: "varbinary(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ServiceTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "StoreItemCategory",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StoreItemCategory", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "CarModels",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CarManufacturerId = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ModelYear = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CarModels", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CarModels_CarManufacturers_CarManufacturerId",
                        column: x => x.CarManufacturerId,
                        principalTable: "CarManufacturers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Surname = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Phone = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Username = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Created = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Gender = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PostalCode = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Image = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    CityId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Users_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AuthTokens",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Value = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Created = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Revoked = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuthTokens", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuthTokens_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CarPartsShopClientDiscounts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Value = table.Column<double>(type: "float", nullable: false),
                    CarPartsShopId = table.Column<int>(type: "int", nullable: false),
                    ClientId = table.Column<int>(type: "int", nullable: true),
                    CarRepairShopId = table.Column<int>(type: "int", nullable: true),
                    Created = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Revoked = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CarPartsShopClientDiscounts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CarPartsShopClientDiscounts_Users_CarPartsShopId",
                        column: x => x.CarPartsShopId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CarPartsShopClientDiscounts_Users_CarRepairShopId",
                        column: x => x.CarRepairShopId,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CarPartsShopClientDiscounts_Users_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "CarRepairShopDiscounts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CarRepairShopId = table.Column<int>(type: "int", nullable: false),
                    Value = table.Column<double>(type: "float", nullable: false),
                    ClientId = table.Column<int>(type: "int", nullable: false),
                    Created = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Revoked = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CarRepairShopDiscounts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CarRepairShopDiscounts_Users_CarRepairShopId",
                        column: x => x.CarRepairShopId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CarRepairShopDiscounts_Users_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "CarRepairShopServices",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CarRepairShopId = table.Column<int>(type: "int", nullable: false),
                    ServiceTypeId = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Price = table.Column<double>(type: "float", nullable: false),
                    Discount = table.Column<double>(type: "float", nullable: false),
                    DiscountedPrice = table.Column<double>(type: "float", nullable: false),
                    State = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ImageData = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Details = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Duration = table.Column<TimeSpan>(type: "time", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CarRepairShopServices", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CarRepairShopServices_ServiceTypes_ServiceTypeId",
                        column: x => x.ServiceTypeId,
                        principalTable: "ServiceTypes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CarRepairShopServices_Users_CarRepairShopId",
                        column: x => x.CarRepairShopId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "StoreItems",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Price = table.Column<double>(type: "float", nullable: false),
                    Discount = table.Column<double>(type: "float", nullable: false),
                    DiscountedPrice = table.Column<double>(type: "float", nullable: false),
                    State = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ImageData = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Details = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CarPartsShopId = table.Column<int>(type: "int", nullable: false),
                    StoreItemCategoryId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StoreItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_StoreItems_StoreItemCategory_StoreItemCategoryId",
                        column: x => x.StoreItemCategoryId,
                        principalTable: "StoreItemCategory",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_StoreItems_Users_CarPartsShopId",
                        column: x => x.CarPartsShopId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Orders",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CarPartsShopId = table.Column<int>(type: "int", nullable: false),
                    CarRepairShopId = table.Column<int>(type: "int", nullable: true),
                    ClientId = table.Column<int>(type: "int", nullable: true),
                    OrderDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ShippingDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    TotalAmount = table.Column<double>(type: "float", nullable: false),
                    ClientDiscountId = table.Column<int>(type: "int", nullable: true),
                    State = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CityId = table.Column<int>(type: "int", nullable: false),
                    ShippingAddress = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ShippingPostalCode = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PaymentMethod = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Orders", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Orders_CarPartsShopClientDiscounts_ClientDiscountId",
                        column: x => x.ClientDiscountId,
                        principalTable: "CarPartsShopClientDiscounts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Orders_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Orders_Users_CarPartsShopId",
                        column: x => x.CarPartsShopId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Orders_Users_CarRepairShopId",
                        column: x => x.CarRepairShopId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Orders_Users_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "StoreItemCarModels",
                columns: table => new
                {
                    StoreItemId = table.Column<int>(type: "int", nullable: false),
                    CarModelId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StoreItemCarModels", x => new { x.StoreItemId, x.CarModelId });
                    table.ForeignKey(
                        name: "FK_StoreItemCarModels_CarModels_CarModelId",
                        column: x => x.CarModelId,
                        principalTable: "CarModels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_StoreItemCarModels_StoreItems_StoreItemId",
                        column: x => x.StoreItemId,
                        principalTable: "StoreItems",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "OrderDetails",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OrderId = table.Column<int>(type: "int", nullable: false),
                    StoreItemId = table.Column<int>(type: "int", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    UnitPrice = table.Column<double>(type: "float", nullable: false),
                    TotalItemsPrice = table.Column<double>(type: "float", nullable: false),
                    TotalItemsPriceDiscounted = table.Column<double>(type: "float", nullable: false),
                    Discount = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrderDetails", x => x.Id);
                    table.ForeignKey(
                        name: "FK_OrderDetails_Orders_OrderId",
                        column: x => x.OrderId,
                        principalTable: "Orders",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_OrderDetails_StoreItems_StoreItemId",
                        column: x => x.StoreItemId,
                        principalTable: "StoreItems",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "CarManufacturers",
                columns: new[] { "Id", "Name" },
                values: new object[] { 1, "Volkswagen" });

            migrationBuilder.InsertData(
                table: "Cities",
                columns: new[] { "Id", "Name" },
                values: new object[] { 1, "Livno" });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "Id", "Description", "Name" },
                values: new object[,]
                {
                    { 1, null, "Admin" },
                    { 2, null, "Client" },
                    { 3, null, "Car Repair Shop" },
                    { 4, null, "Car Parts Shop" }
                });

            migrationBuilder.InsertData(
                table: "ServiceTypes",
                columns: new[] { "Id", "Image", "Name" },
                values: new object[,]
                {
                    { 1, new byte[] { 137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 150, 0, 0, 0, 150, 8, 6, 0, 0, 0, 60, 1, 113, 226, 0, 0, 0, 4, 115, 66, 73, 84, 8, 8, 8, 8, 124, 8, 100, 136, 0, 0, 17, 123, 73, 68, 65, 84, 120, 156, 237, 157, 123, 180, 92, 85, 125, 199, 63, 123, 238, 13, 121, 92, 66, 18, 72, 136, 129, 66, 0, 65, 147, 242, 6, 139, 32, 17, 44, 88, 68, 17, 74, 140, 5, 66, 241, 65, 92, 93, 188, 42, 20, 22, 160, 54, 172, 224, 3, 44, 200, 35, 188, 74, 16, 69, 158, 137, 9, 173, 65, 172, 138, 21, 80, 169, 205, 98, 1, 141, 88, 30, 209, 38, 162, 229, 97, 2, 72, 67, 18, 146, 155, 155, 251, 152, 111, 255, 248, 157, 73, 230, 222, 204, 204, 57, 51, 115, 206, 156, 115, 230, 238, 207, 90, 179, 178, 50, 119, 206, 62, 251, 236, 253, 59, 251, 241, 123, 109, 240, 120, 60, 30, 143, 199, 227, 241, 164, 142, 36, 39, 105, 95, 73, 231, 74, 154, 33, 201, 165, 93, 39, 79, 252, 72, 218, 83, 210, 28, 73, 211, 37, 21, 146, 190, 217, 225, 146, 158, 146, 212, 35, 169, 40, 169, 87, 210, 127, 74, 218, 47, 209, 27, 123, 90, 134, 164, 189, 37, 253, 68, 210, 166, 160, 143, 183, 72, 90, 46, 233, 253, 73, 221, 112, 146, 164, 23, 84, 153, 101, 146, 38, 37, 114, 99, 79, 203, 144, 180, 179, 164, 39, 2, 129, 26, 202, 74, 73, 83, 147, 184, 233, 221, 85, 132, 170, 196, 181, 177, 223, 212, 211, 82, 36, 93, 22, 210, 199, 15, 197, 125, 195, 14, 73, 175, 134, 220, 244, 5, 73, 35, 99, 189, 177, 167, 165, 72, 186, 47, 164, 143, 55, 72, 234, 136, 82, 86, 212, 69, 153, 3, 58, 67, 126, 51, 25, 24, 17, 177, 60, 79, 54, 217, 33, 228, 239, 157, 68, 148, 153, 122, 4, 43, 140, 48, 193, 243, 100, 159, 40, 253, 28, 73, 11, 16, 231, 54, 210, 171, 29, 60, 91, 73, 86, 63, 225, 25, 182, 120, 193, 242, 36, 130, 23, 44, 79, 34, 120, 193, 242, 36, 130, 23, 44, 79, 34, 120, 193, 242, 36, 130, 23, 44, 79, 34, 120, 193, 242, 36, 130, 23, 44, 79, 34, 120, 193, 242, 36, 130, 23, 44, 79, 34, 120, 193, 242, 36, 66, 91, 122, 36, 72, 26, 1, 140, 6, 34, 249, 14, 165, 136, 128, 94, 231, 92, 119, 218, 21, 137, 155, 182, 18, 44, 153, 123, 244, 165, 192, 167, 48, 255, 176, 60, 120, 92, 244, 74, 122, 12, 56, 207, 57, 247, 106, 218, 149, 137, 139, 182, 16, 44, 73, 163, 128, 127, 2, 102, 3, 187, 146, 15, 129, 42, 49, 18, 56, 9, 88, 46, 105, 9, 48, 215, 57, 183, 33, 229, 58, 53, 77, 238, 215, 88, 146, 38, 2, 15, 0, 23, 146, 159, 81, 170, 18, 147, 128, 243, 129, 7, 37, 189, 43, 237, 202, 52, 75, 238, 5, 11, 248, 6, 240, 9, 218, 227, 89, 10, 192, 71, 128, 27, 211, 174, 72, 179, 228, 186, 51, 36, 157, 0, 156, 73, 126, 71, 169, 106, 204, 146, 116, 114, 218, 149, 104, 134, 220, 10, 86, 16, 45, 114, 33, 182, 70, 105, 55, 118, 0, 46, 150, 52, 58, 237, 138, 52, 74, 110, 5, 11, 56, 29, 155, 54, 218, 149, 99, 128, 179, 211, 174, 68, 163, 228, 82, 176, 36, 237, 6, 92, 67, 155, 236, 106, 171, 208, 1, 124, 77, 73, 68, 31, 183, 128, 92, 10, 22, 112, 22, 176, 123, 218, 149, 104, 1, 59, 3, 103, 43, 135, 137, 87, 114, 39, 88, 146, 14, 2, 230, 145, 195, 186, 55, 200, 101, 192, 97, 105, 87, 162, 94, 242, 216, 57, 151, 0, 93, 105, 87, 162, 133, 140, 1, 190, 16, 53, 180, 61, 43, 228, 74, 176, 36, 29, 12, 156, 146, 118, 61, 82, 224, 35, 192, 81, 105, 87, 162, 30, 114, 35, 88, 146, 198, 1, 75, 129, 9, 105, 215, 37, 5, 118, 2, 150, 74, 218, 37, 237, 138, 68, 165, 101, 187, 42, 73, 135, 0, 251, 97, 137, 67, 74, 139, 209, 34, 240, 39, 224, 73, 231, 220, 166, 144, 34, 62, 9, 236, 153, 92, 13, 51, 207, 68, 76, 25, 124, 107, 173, 31, 73, 26, 3, 28, 137, 153, 183, 74, 3, 135, 128, 126, 224, 37, 224, 87, 206, 57, 37, 88, 207, 232, 72, 26, 33, 105, 77, 72, 138, 155, 117, 146, 118, 172, 112, 237, 206, 146, 110, 145, 101, 1, 172, 196, 128, 164, 223, 72, 58, 179, 90, 26, 36, 73, 83, 37, 253, 81, 149, 19, 130, 13, 39, 214, 72, 218, 167, 70, 31, 157, 42, 233, 57, 89, 155, 86, 162, 71, 210, 119, 84, 37, 73, 158, 164, 37, 33, 247, 239, 150, 20, 150, 145, 38, 58, 106, 80, 176, 100, 121, 181, 150, 40, 186, 64, 204, 169, 114, 255, 5, 17, 175, 31, 14, 220, 175, 10, 234, 7, 73, 167, 75, 234, 143, 88, 198, 247, 85, 97, 51, 160, 24, 5, 43, 233, 53, 214, 169, 152, 129, 56, 170, 30, 230, 139, 178, 181, 212, 86, 36, 237, 205, 240, 92, 176, 87, 227, 4, 224, 128, 242, 47, 36, 141, 5, 190, 76, 244, 254, 60, 9, 56, 35, 222, 106, 13, 38, 105, 193, 58, 158, 250, 214, 113, 239, 198, 76, 25, 0, 200, 108, 101, 119, 3, 83, 98, 174, 87, 158, 153, 4, 220, 43, 169, 92, 229, 114, 20, 240, 30, 162, 191, 192, 157, 192, 71, 227, 174, 88, 57, 73, 11, 86, 189, 26, 227, 2, 131, 53, 234, 211, 176, 133, 104, 238, 52, 207, 9, 226, 128, 67, 129, 67, 202, 190, 155, 66, 253, 125, 153, 104, 155, 38, 189, 43, 124, 24, 152, 67, 120, 10, 194, 18, 69, 224, 245, 178, 255, 255, 22, 27, 250, 71, 227, 133, 171, 132, 128, 45, 192, 175, 203, 190, 123, 19, 107, 187, 168, 194, 213, 11, 60, 24, 115, 189, 6, 145, 244, 136, 245, 239, 192, 149, 192, 27, 216, 131, 43, 248, 84, 66, 192, 98, 224, 17, 176, 131, 10, 128, 233, 152, 230, 185, 19, 51, 202, 250, 143, 125, 70, 50, 88, 245, 242, 56, 112, 31, 48, 80, 163, 109, 133, 245, 193, 91, 192, 215, 129, 31, 84, 249, 109, 44, 36, 58, 98, 5, 250, 146, 107, 36, 125, 3, 155, 226, 198, 99, 230, 152, 247, 1, 95, 8, 190, 115, 216, 67, 63, 10, 156, 227, 156, 219, 82, 86, 183, 155, 129, 163, 241, 163, 213, 80, 132, 181, 223, 111, 0, 156, 115, 189, 146, 46, 0, 118, 100, 176, 55, 237, 106, 224, 58, 224, 41, 96, 35, 176, 30, 88, 237, 156, 235, 111, 121, 141, 43, 161, 38, 244, 88, 53, 202, 156, 33, 105, 163, 76, 231, 242, 160, 164, 9, 146, 118, 145, 233, 89, 30, 151, 180, 191, 76, 127, 181, 88, 213, 117, 96, 195, 145, 45, 146, 174, 151, 212, 37, 105, 63, 73, 63, 147, 244, 128, 164, 93, 131, 239, 238, 151, 181, 105, 159, 164, 227, 235, 236, 231, 124, 232, 177, 66, 202, 236, 144, 244, 45, 73, 119, 73, 26, 39, 105, 188, 164, 165, 218, 166, 243, 122, 86, 210, 1, 146, 58, 37, 93, 163, 109, 199, 172, 12, 103, 182, 72, 186, 65, 214, 38, 239, 149, 244, 180, 172, 77, 138, 146, 126, 44, 19, 174, 157, 36, 221, 41, 19, 182, 186, 12, 215, 106, 7, 193, 26, 82, 254, 4, 73, 191, 212, 246, 130, 179, 82, 210, 238, 178, 131, 161, 174, 80, 117, 141, 242, 112, 225, 106, 89, 91, 76, 208, 246, 199, 207, 20, 37, 253, 90, 22, 181, 212, 104, 63, 231, 70, 65, 26, 138, 204, 188, 240, 29, 224, 3, 108, 191, 150, 218, 23, 91, 123, 29, 10, 220, 0, 92, 12, 172, 109, 105, 5, 179, 193, 58, 96, 46, 182, 232, 222, 31, 120, 12, 248, 243, 33, 191, 113, 192, 65, 152, 142, 43, 31, 225, 99, 74, 104, 196, 146, 77, 129, 15, 41, 124, 138, 251, 189, 164, 79, 72, 42, 72, 58, 65, 210, 75, 17, 174, 105, 23, 94, 150, 116, 146, 236, 217, 79, 150, 180, 74, 181, 159, 189, 52, 45, 214, 125, 104, 150, 218, 97, 42, 148, 52, 70, 210, 99, 33, 141, 84, 78, 143, 164, 243, 101, 83, 193, 116, 73, 175, 69, 188, 46, 207, 108, 148, 116, 164, 236, 153, 207, 146, 117, 108, 20, 138, 178, 245, 87, 189, 47, 122, 91, 76, 133, 51, 129, 99, 137, 174, 74, 24, 137, 77, 135, 23, 1, 43, 129, 191, 192, 244, 94, 197, 68, 106, 151, 62, 171, 128, 19, 129, 255, 2, 206, 1, 22, 96, 138, 226, 40, 56, 76, 165, 115, 102, 50, 85, 11, 39, 21, 193, 146, 41, 63, 255, 129, 250, 245, 104, 163, 176, 117, 198, 149, 64, 55, 112, 46, 176, 136, 234, 138, 193, 60, 34, 76, 121, 249, 49, 224, 89, 224, 139, 216, 11, 85, 239, 198, 200, 1, 231, 43, 233, 211, 81, 171, 144, 214, 136, 53, 10, 56, 176, 193, 107, 71, 3, 87, 96, 218, 230, 78, 224, 239, 176, 220, 13, 237, 48, 114, 21, 129, 239, 99, 35, 205, 91, 192, 15, 129, 175, 98, 214, 135, 70, 152, 142, 181, 117, 203, 73, 43, 46, 175, 131, 230, 132, 218, 97, 145, 43, 247, 99, 182, 200, 207, 1, 243, 129, 177, 228, 87, 75, 47, 76, 59, 190, 2, 115, 191, 190, 19, 243, 244, 104, 230, 121, 10, 164, 148, 35, 44, 45, 193, 138, 163, 243, 29, 182, 6, 89, 8, 92, 142, 25, 98, 255, 143, 234, 182, 200, 172, 227, 130, 207, 52, 44, 24, 247, 68, 226, 105, 167, 84, 102, 165, 44, 69, 18, 175, 1, 54, 99, 190, 218, 81, 195, 187, 28, 112, 28, 182, 192, 29, 206, 20, 177, 23, 107, 128, 140, 4, 242, 166, 37, 88, 149, 222, 162, 75, 129, 127, 5, 246, 193, 214, 24, 159, 3, 118, 171, 163, 204, 1, 76, 121, 218, 79, 254, 214, 91, 5, 172, 47, 118, 166, 190, 169, 235, 13, 108, 196, 126, 16, 51, 72, 31, 1, 252, 148, 193, 35, 93, 42, 167, 222, 166, 37, 88, 227, 216, 126, 152, 159, 226, 156, 235, 197, 124, 176, 230, 73, 186, 19, 11, 78, 61, 5, 115, 17, 9, 107, 160, 85, 152, 250, 226, 79, 229, 81, 40, 202, 112, 120, 122, 169, 158, 65, 29, 119, 1, 126, 129, 105, 212, 107, 213, 185, 31, 248, 35, 182, 115, 188, 222, 57, 247, 74, 233, 15, 146, 134, 246, 167, 3, 246, 192, 54, 2, 45, 37, 45, 193, 58, 150, 237, 71, 173, 11, 37, 221, 226, 156, 235, 3, 112, 206, 189, 134, 9, 214, 37, 146, 14, 5, 78, 195, 22, 236, 71, 97, 139, 244, 161, 188, 7, 248, 26, 112, 158, 36, 128, 107, 129, 15, 99, 211, 106, 214, 132, 75, 192, 102, 73, 143, 2, 151, 59, 231, 36, 105, 46, 182, 139, 171, 84, 215, 77, 192, 211, 192, 51, 192, 191, 96, 33, 92, 131, 70, 229, 64, 173, 48, 52, 87, 88, 233, 187, 103, 227, 127, 132, 24, 80, 140, 154, 119, 73, 123, 72, 122, 177, 194, 245, 189, 146, 142, 8, 185, 214, 73, 122, 183, 204, 194, 95, 201, 149, 166, 91, 210, 69, 50, 243, 199, 103, 131, 50, 179, 74, 81, 210, 185, 178, 103, 154, 35, 211, 178, 15, 165, 79, 166, 13, 63, 80, 33, 250, 40, 153, 39, 200, 59, 21, 202, 88, 37, 233, 189, 17, 251, 57, 159, 38, 29, 153, 191, 213, 51, 170, 110, 198, 185, 67, 17, 166, 174, 160, 62, 159, 15, 238, 57, 148, 245, 146, 142, 149, 52, 74, 230, 155, 212, 23, 82, 239, 52, 24, 144, 217, 243, 186, 100, 117, 125, 179, 194, 111, 54, 72, 154, 39, 75, 220, 27, 214, 30, 78, 210, 124, 85, 110, 215, 162, 164, 21, 146, 38, 71, 40, 39, 183, 130, 245, 113, 213, 142, 125, 235, 145, 101, 147, 137, 90, 175, 11, 84, 121, 84, 250, 31, 153, 107, 73, 135, 204, 102, 150, 53, 254, 32, 11, 228, 221, 67, 210, 234, 10, 127, 239, 147, 116, 169, 34, 174, 15, 101, 182, 211, 48, 103, 200, 217, 17, 202, 201, 173, 173, 112, 207, 144, 123, 238, 0, 92, 37, 11, 19, 143, 194, 183, 128, 59, 216, 94, 119, 181, 47, 230, 138, 51, 6, 51, 29, 173, 174, 240, 155, 180, 120, 29, 179, 253, 109, 194, 92, 175, 43, 185, 184, 220, 3, 220, 18, 37, 20, 94, 118, 88, 194, 87, 8, 15, 88, 105, 105, 122, 130, 86, 11, 86, 216, 195, 59, 44, 222, 237, 54, 73, 227, 195, 10, 11, 118, 145, 11, 128, 119, 134, 252, 169, 128, 237, 38, 111, 197, 22, 174, 87, 2, 125, 117, 215, 54, 126, 250, 49, 159, 178, 39, 48, 95, 244, 83, 168, 188, 88, 95, 24, 60, 91, 77, 100, 129, 170, 215, 99, 129, 193, 97, 163, 91, 124, 83, 88, 4, 90, 45, 88, 81, 134, 246, 78, 44, 247, 230, 252, 224, 109, 12, 99, 37, 240, 191, 21, 190, 47, 96, 39, 84, 124, 10, 27, 1, 174, 35, 93, 99, 245, 0, 112, 19, 166, 115, 58, 21, 27, 181, 170, 233, 172, 222, 14, 43, 44, 104, 155, 235, 128, 191, 39, 37, 93, 85, 45, 178, 164, 121, 31, 202, 89, 192, 120, 73, 11, 128, 101, 53, 178, 209, 140, 195, 210, 252, 84, 162, 128, 153, 71, 214, 96, 211, 197, 83, 152, 55, 106, 75, 223, 94, 44, 142, 239, 121, 224, 71, 88, 160, 233, 124, 106, 11, 67, 213, 181, 170, 204, 143, 125, 111, 204, 56, 253, 73, 50, 224, 5, 92, 137, 44, 11, 86, 39, 246, 102, 127, 28, 88, 39, 105, 61, 240, 34, 166, 207, 89, 139, 105, 215, 187, 48, 147, 206, 159, 213, 40, 103, 2, 166, 211, 218, 140, 41, 95, 87, 36, 88, 231, 90, 116, 96, 154, 241, 27, 177, 117, 85, 173, 209, 251, 171, 146, 126, 140, 25, 165, 11, 216, 51, 28, 142, 229, 108, 24, 139, 189, 72, 99, 66, 202, 72, 149, 44, 11, 86, 137, 78, 44, 55, 212, 68, 44, 183, 67, 35, 9, 66, 166, 99, 190, 243, 121, 225, 184, 224, 147, 91, 50, 57, 140, 122, 242, 79, 214, 4, 171, 136, 169, 6, 158, 37, 127, 134, 228, 52, 40, 2, 255, 141, 217, 14, 51, 213, 94, 89, 155, 10, 127, 2, 252, 45, 182, 184, 254, 45, 241, 228, 27, 93, 31, 148, 251, 60, 182, 221, 79, 75, 159, 229, 176, 117, 214, 254, 152, 219, 113, 168, 58, 37, 2, 27, 129, 89, 152, 145, 249, 30, 224, 175, 201, 200, 186, 43, 107, 130, 117, 187, 115, 174, 164, 193, 111, 40, 248, 117, 8, 107, 129, 207, 96, 137, 70, 70, 96, 185, 165, 210, 122, 230, 1, 76, 0, 122, 48, 227, 248, 61, 52, 159, 247, 107, 52, 208, 227, 156, 91, 47, 233, 102, 44, 161, 90, 38, 84, 15, 89, 19, 172, 117, 193, 191, 221, 88, 210, 219, 122, 252, 177, 134, 242, 50, 38, 84, 203, 48, 207, 136, 155, 177, 13, 64, 154, 108, 192, 162, 140, 22, 98, 155, 144, 197, 216, 134, 164, 81, 222, 102, 155, 114, 120, 61, 25, 154, 14, 179, 182, 198, 234, 0, 8, 92, 66, 174, 160, 113, 109, 249, 91, 192, 25, 206, 185, 39, 48, 101, 235, 189, 216, 104, 229, 82, 254, 140, 195, 204, 80, 231, 3, 203, 129, 79, 19, 65, 25, 90, 133, 62, 224, 43, 101, 167, 177, 22, 200, 200, 52, 8, 217, 27, 177, 102, 74, 122, 218, 57, 215, 131, 9, 195, 11, 216, 122, 100, 31, 44, 1, 91, 148, 208, 241, 1, 76, 171, 253, 140, 164, 179, 48, 5, 105, 38, 166, 135, 128, 146, 109, 175, 15, 19, 178, 43, 177, 240, 174, 40, 117, 124, 19, 91, 47, 190, 130, 41, 91, 159, 6, 144, 101, 155, 158, 69, 134, 250, 51, 51, 21, 9, 184, 0, 56, 80, 210, 181, 88, 78, 242, 55, 128, 239, 98, 233, 34, 15, 35, 252, 104, 222, 205, 152, 237, 236, 97, 204, 153, 240, 14, 178, 121, 60, 202, 120, 108, 106, 126, 25, 139, 198, 121, 23, 102, 44, 15, 51, 190, 175, 197, 188, 76, 159, 196, 150, 11, 123, 73, 218, 19, 203, 149, 117, 60, 25, 154, 129, 178, 38, 88, 35, 176, 6, 170, 43, 175, 83, 64, 17, 184, 29, 203, 30, 60, 21, 248, 38, 141, 199, 227, 181, 130, 17, 192, 109, 192, 9, 206, 185, 185, 146, 132, 5, 167, 214, 242, 121, 159, 134, 121, 109, 100, 158, 204, 72, 120, 147, 20, 177, 233, 100, 30, 102, 238, 88, 132, 45, 138, 51, 179, 230, 168, 194, 94, 192, 98, 73, 83, 128, 171, 177, 40, 239, 44, 120, 97, 52, 77, 214, 70, 172, 48, 132, 173, 51, 94, 194, 18, 188, 22, 177, 142, 248, 5, 112, 147, 115, 110, 139, 164, 233, 88, 124, 225, 207, 200, 190, 96, 149, 18, 213, 238, 231, 156, 251, 15, 73, 87, 97, 27, 143, 143, 178, 237, 104, 152, 2, 182, 241, 152, 70, 74, 193, 167, 141, 144, 55, 193, 42, 2, 39, 59, 231, 158, 169, 246, 3, 231, 220, 114, 204, 112, 157, 59, 2, 31, 172, 91, 130, 207, 86, 100, 135, 51, 173, 196, 194, 195, 114, 65, 222, 166, 194, 94, 130, 132, 174, 195, 140, 13, 216, 200, 150, 27, 242, 38, 88, 69, 114, 214, 192, 49, 81, 74, 101, 158, 27, 90, 45, 88, 113, 52, 78, 174, 26, 120, 184, 18, 85, 176, 106, 37, 254, 47, 17, 197, 156, 208, 172, 107, 240, 64, 132, 122, 180, 35, 34, 158, 182, 139, 114, 159, 176, 191, 71, 106, 255, 168, 130, 85, 196, 236, 120, 170, 241, 121, 21, 243, 30, 168, 69, 51, 209, 50, 194, 188, 63, 51, 99, 15, 107, 21, 129, 137, 235, 69, 154, 123, 169, 86, 71, 248, 77, 55, 131, 79, 16, 25, 250, 89, 71, 196, 246, 143, 188, 29, 15, 204, 6, 83, 176, 148, 141, 67, 175, 235, 193, 78, 60, 168, 25, 89, 34, 75, 21, 189, 156, 198, 66, 145, 54, 2, 71, 59, 231, 158, 107, 224, 218, 220, 35, 105, 47, 236, 252, 156, 113, 33, 63, 173, 196, 90, 224, 0, 231, 220, 154, 144, 123, 140, 4, 118, 101, 123, 183, 103, 97, 27, 167, 215, 157, 115, 155, 163, 220, 112, 235, 197, 178, 16, 238, 15, 98, 65, 12, 19, 169, 111, 253, 85, 58, 26, 246, 21, 224, 235, 206, 185, 170, 73, 40, 36, 77, 195, 236, 128, 135, 19, 77, 47, 83, 4, 94, 195, 210, 81, 47, 26, 154, 179, 96, 56, 33, 233, 52, 204, 127, 127, 15, 162, 183, 221, 115, 192, 28, 231, 92, 213, 252, 13, 178, 227, 251, 254, 17, 211, 149, 149, 31, 173, 28, 133, 34, 102, 72, 95, 4, 252, 220, 57, 55, 64, 169, 128, 192, 255, 233, 70, 204, 218, 94, 241, 248, 220, 58, 184, 21, 184, 168, 86, 176, 101, 16, 144, 58, 3, 11, 130, 232, 160, 242, 131, 148, 132, 245, 53, 44, 74, 167, 187, 201, 122, 181, 5, 129, 16, 28, 137, 105, 237, 59, 169, 222, 118, 69, 204, 179, 244, 151, 97, 231, 109, 75, 250, 43, 204, 168, 221, 140, 177, 190, 23, 179, 235, 94, 226, 156, 91, 235, 130, 138, 254, 0, 179, 207, 197, 161, 169, 238, 193, 148, 121, 155, 9, 95, 48, 70, 93, 51, 148, 215, 171, 23, 139, 35, 252, 182, 115, 110, 89, 221, 181, 203, 17, 146, 14, 7, 206, 195, 188, 59, 118, 96, 251, 233, 41, 140, 176, 254, 116, 65, 185, 147, 217, 118, 96, 86, 51, 8, 75, 130, 119, 156, 147, 116, 12, 118, 210, 65, 150, 92, 75, 194, 40, 141, 102, 55, 1, 95, 42, 13, 191, 237, 66, 16, 59, 248, 101, 44, 25, 93, 165, 53, 109, 150, 17, 48, 171, 128, 217, 165, 242, 102, 218, 113, 216, 139, 112, 49, 118, 236, 92, 187, 113, 24, 230, 233, 48, 138, 124, 9, 21, 88, 125, 63, 84, 32, 31, 94, 0, 213, 232, 196, 22, 178, 237, 198, 110, 228, 239, 101, 47, 103, 175, 2, 249, 78, 190, 95, 218, 49, 182, 27, 191, 195, 214, 146, 121, 101, 160, 128, 185, 156, 228, 113, 11, 95, 196, 130, 17, 218, 113, 1, 191, 2, 115, 84, 204, 198, 73, 168, 245, 33, 96, 153, 147, 52, 14, 19, 174, 131, 137, 103, 74, 236, 199, 34, 71, 146, 50, 156, 22, 177, 8, 158, 249, 192, 61, 237, 182, 112, 47, 17, 232, 21, 103, 99, 107, 173, 93, 73, 206, 174, 219, 129, 237, 12, 227, 200, 5, 33, 224, 247, 192, 251, 237, 127, 210, 100, 73, 63, 82, 60, 7, 77, 46, 146, 52, 82, 150, 7, 212, 37, 241, 105, 242, 225, 115, 71, 82, 237, 24, 124, 70, 72, 154, 169, 218, 153, 22, 163, 48, 32, 233, 81, 73, 83, 97, 176, 230, 125, 20, 240, 55, 216, 91, 50, 145, 250, 189, 21, 7, 48, 207, 205, 207, 59, 231, 126, 23, 83, 155, 122, 90, 128, 164, 9, 192, 183, 137, 174, 209, 47, 103, 0, 179, 33, 46, 198, 44, 35, 61, 80, 159, 173, 176, 180, 197, 175, 116, 227, 34, 208, 55, 156, 205, 45, 237, 64, 89, 31, 87, 138, 81, 140, 191, 143, 131, 105, 237, 73, 73, 155, 101, 7, 94, 247, 14, 249, 244, 72, 122, 94, 166, 197, 247, 228, 20, 73, 55, 85, 233, 227, 45, 193, 247, 43, 20, 241, 152, 186, 168, 186, 146, 2, 22, 82, 85, 43, 53, 244, 238, 228, 200, 217, 223, 83, 145, 201, 212, 238, 227, 169, 88, 31, 135, 142, 90, 81, 119, 26, 165, 16, 241, 56, 202, 242, 100, 151, 176, 62, 140, 34, 7, 145, 10, 242, 120, 26, 194, 11, 150, 39, 17, 188, 96, 121, 18, 193, 11, 150, 39, 17, 188, 96, 121, 18, 193, 11, 150, 39, 17, 188, 96, 121, 18, 193, 11, 150, 39, 17, 188, 96, 121, 18, 193, 11, 150, 39, 17, 188, 96, 121, 18, 193, 11, 150, 39, 17, 188, 96, 121, 18, 193, 11, 150, 39, 17, 188, 96, 121, 18, 193, 11, 150, 39, 17, 18, 141, 182, 149, 52, 9, 152, 131, 133, 241, 143, 195, 11, 114, 218, 20, 177, 60, 99, 143, 0, 119, 57, 231, 222, 72, 234, 70, 137, 9, 86, 224, 255, 254, 48, 112, 84, 82, 247, 240, 52, 204, 12, 96, 150, 164, 15, 38, 149, 30, 42, 206, 17, 100, 107, 224, 104, 16, 91, 246, 8, 165, 192, 69, 79, 22, 57, 4, 120, 92, 210, 190, 101, 223, 197, 22, 96, 28, 167, 96, 189, 13, 20, 101, 41, 13, 239, 6, 142, 137, 185, 124, 79, 188, 20, 176, 4, 110, 119, 75, 218, 39, 248, 46, 82, 26, 200, 168, 133, 199, 65, 63, 240, 207, 216, 73, 91, 75, 128, 191, 36, 191, 25, 108, 134, 27, 51, 128, 165, 146, 118, 3, 126, 72, 76, 103, 249, 196, 33, 88, 253, 216, 225, 72, 63, 5, 190, 7, 188, 47, 134, 50, 61, 173, 229, 64, 224, 223, 176, 188, 11, 95, 194, 178, 50, 54, 69, 179, 130, 181, 17, 184, 10, 120, 8, 203, 61, 58, 35, 134, 50, 61, 173, 167, 128, 37, 123, 187, 21, 59, 104, 115, 46, 118, 204, 74, 195, 52, 179, 43, 236, 199, 50, 248, 222, 137, 73, 251, 17, 205, 84, 196, 147, 9, 142, 6, 30, 0, 78, 196, 250, 247, 6, 26, 148, 145, 70, 71, 151, 1, 108, 250, 123, 20, 88, 138, 159, 254, 218, 137, 131, 176, 181, 214, 207, 129, 203, 105, 240, 236, 162, 122, 142, 60, 41, 177, 17, 59, 211, 120, 21, 182, 80, 255, 64, 29, 229, 120, 178, 79, 1, 27, 40, 110, 199, 214, 205, 87, 48, 120, 90, 140, 164, 146, 168, 103, 152, 43, 101, 42, 190, 10, 59, 4, 252, 187, 192, 216, 58, 174, 247, 228, 139, 25, 88, 31, 159, 138, 9, 219, 213, 212, 161, 231, 138, 164, 18, 8, 210, 219, 220, 7, 252, 10, 211, 87, 221, 8, 76, 168, 183, 166, 158, 220, 81, 58, 195, 103, 30, 118, 216, 195, 135, 129, 153, 181, 14, 135, 40, 81, 79, 126, 172, 177, 192, 44, 44, 69, 227, 248, 198, 234, 233, 201, 41, 107, 129, 203, 128, 239, 57, 231, 214, 71, 185, 160, 158, 17, 107, 38, 118, 6, 206, 142, 13, 87, 207, 147, 103, 186, 129, 11, 128, 123, 163, 140, 88, 161, 139, 238, 64, 168, 206, 0, 238, 194, 11, 213, 112, 102, 12, 112, 27, 240, 217, 40, 121, 96, 163, 236, 230, 102, 3, 11, 104, 236, 56, 51, 79, 123, 209, 133, 29, 51, 243, 153, 176, 204, 126, 53, 37, 79, 210, 41, 192, 66, 252, 72, 229, 25, 204, 38, 224, 28, 44, 153, 109, 197, 105, 177, 162, 212, 5, 105, 154, 207, 196, 175, 169, 60, 149, 233, 194, 14, 56, 168, 58, 45, 86, 27, 206, 102, 99, 10, 50, 191, 251, 243, 84, 163, 11, 184, 153, 42, 211, 226, 118, 210, 22, 76, 127, 139, 130, 11, 61, 158, 48, 186, 177, 105, 113, 97, 249, 180, 184, 85, 210, 134, 76, 127, 94, 168, 60, 81, 25, 3, 220, 1, 156, 93, 62, 45, 150, 15, 97, 167, 227, 167, 63, 79, 99, 116, 97, 138, 243, 79, 151, 132, 171, 116, 38, 244, 46, 216, 81, 102, 94, 168, 60, 205, 240, 14, 112, 176, 115, 238, 15, 165, 17, 235, 16, 96, 167, 20, 43, 228, 105, 15, 186, 48, 135, 193, 173, 83, 225, 147, 216, 33, 209, 73, 28, 3, 231, 25, 30, 8, 120, 14, 59, 162, 112, 208, 233, 95, 99, 128, 211, 216, 118, 172, 133, 15, 134, 240, 68, 65, 152, 23, 196, 43, 192, 18, 231, 220, 166, 148, 235, 227, 241, 120, 60, 30, 143, 199, 211, 182, 252, 63, 7, 208, 171, 194, 39, 28, 186, 0, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130 }, "Repairs" },
                    { 2, new byte[] { 137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 150, 0, 0, 0, 150, 8, 6, 0, 0, 0, 60, 1, 113, 226, 0, 0, 0, 4, 115, 66, 73, 84, 8, 8, 8, 8, 124, 8, 100, 136, 0, 0, 18, 249, 73, 68, 65, 84, 120, 156, 237, 157, 105, 148, 156, 85, 153, 128, 159, 155, 238, 16, 146, 16, 22, 89, 68, 112, 6, 21, 209, 17, 220, 0, 17, 69, 24, 144, 113, 3, 65, 162, 4, 199, 5, 117, 64, 65, 86, 65, 116, 20, 69, 81, 81, 28, 80, 142, 71, 199, 5, 65, 84, 64, 220, 64, 81, 71, 71, 81, 148, 193, 163, 209, 97, 55, 32, 142, 2, 10, 200, 46, 1, 89, 18, 2, 233, 229, 153, 31, 239, 87, 233, 234, 234, 170, 238, 218, 171, 210, 117, 159, 115, 114, 146, 84, 125, 203, 173, 251, 189, 223, 123, 239, 125, 183, 11, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 11, 164, 94, 55, 160, 17, 212, 77, 129, 3, 129, 157, 128, 185, 172, 101, 237, 175, 131, 49, 224, 78, 224, 75, 41, 165, 63, 244, 186, 49, 173, 208, 247, 15, 70, 77, 192, 126, 192, 17, 192, 206, 192, 66, 96, 168, 167, 141, 234, 44, 2, 171, 128, 63, 2, 23, 2, 103, 165, 148, 238, 233, 109, 147, 26, 167, 175, 5, 75, 93, 23, 56, 8, 56, 25, 216, 168, 199, 205, 233, 5, 99, 192, 13, 192, 59, 129, 159, 165, 148, 236, 113, 123, 234, 166, 111, 5, 171, 208, 84, 199, 2, 167, 0, 235, 148, 125, 245, 24, 112, 57, 112, 41, 240, 112, 247, 91, 214, 49, 230, 1, 207, 7, 254, 25, 216, 160, 226, 187, 229, 192, 27, 83, 74, 63, 235, 122, 171, 102, 27, 234, 161, 234, 223, 213, 113, 131, 113, 245, 6, 245, 85, 234, 188, 94, 183, 175, 19, 168, 67, 234, 115, 212, 31, 168, 163, 78, 48, 174, 222, 161, 62, 167, 215, 109, 92, 171, 81, 55, 87, 111, 175, 232, 216, 235, 212, 29, 122, 221, 182, 110, 80, 252, 254, 239, 86, 8, 151, 234, 233, 234, 156, 94, 183, 111, 173, 164, 120, 107, 191, 173, 142, 149, 117, 232, 106, 117, 255, 94, 183, 173, 155, 168, 155, 168, 151, 150, 105, 108, 213, 7, 212, 237, 122, 221, 182, 181, 18, 245, 249, 234, 125, 21, 111, 234, 247, 212, 225, 94, 183, 173, 219, 168, 59, 170, 203, 43, 52, 247, 87, 179, 214, 106, 16, 117, 97, 49, 4, 148, 191, 165, 171, 213, 23, 247, 186, 109, 189, 66, 253, 86, 197, 75, 118, 191, 186, 107, 175, 219, 181, 86, 161, 30, 86, 33, 84, 170, 191, 86, 215, 153, 249, 236, 217, 137, 250, 2, 245, 193, 10, 173, 117, 147, 186, 73, 175, 219, 182, 86, 80, 204, 173, 126, 83, 33, 84, 183, 170, 207, 238, 117, 219, 122, 137, 58, 71, 61, 209, 169, 19, 249, 67, 123, 221, 182, 190, 167, 232, 188, 67, 213, 71, 203, 58, 110, 68, 253, 152, 97, 207, 26, 104, 140, 85, 226, 13, 21, 218, 252, 154, 172, 181, 102, 64, 125, 186, 122, 79, 69, 199, 221, 172, 110, 216, 235, 182, 245, 11, 234, 43, 213, 21, 101, 253, 51, 166, 158, 148, 95, 188, 26, 20, 218, 234, 116, 167, 154, 23, 14, 232, 117, 219, 250, 137, 98, 170, 112, 190, 147, 13, 198, 119, 171, 207, 234, 117, 219, 250, 18, 245, 229, 197, 155, 88, 222, 97, 63, 81, 23, 244, 186, 109, 253, 134, 186, 147, 97, 203, 42, 245, 213, 152, 97, 165, 95, 216, 235, 182, 245, 21, 133, 182, 186, 172, 98, 82, 122, 175, 250, 212, 94, 183, 173, 95, 81, 207, 172, 152, 50, 60, 166, 46, 233, 117, 187, 250, 10, 245, 144, 162, 99, 202, 231, 13, 31, 49, 27, 0, 107, 162, 110, 171, 254, 165, 226, 101, 188, 94, 125, 92, 175, 219, 214, 23, 168, 91, 170, 127, 174, 232, 160, 171, 205, 19, 246, 105, 81, 147, 122, 184, 186, 170, 172, 223, 70, 212, 19, 236, 163, 137, 252, 140, 13, 41, 30, 244, 91, 128, 215, 1, 243, 167, 57, 103, 5, 112, 14, 112, 78, 74, 233, 177, 58, 174, 251, 65, 224, 195, 64, 185, 118, 122, 75, 74, 233, 220, 153, 206, 29, 116, 10, 1, 186, 18, 40, 119, 202, 223, 2, 60, 47, 165, 116, 95, 29, 231, 111, 5, 28, 5, 252, 11, 181, 131, 38, 5, 238, 5, 78, 5, 46, 73, 41, 141, 183, 210, 230, 202, 6, 188, 64, 93, 86, 188, 17, 149, 22, 241, 74, 198, 139, 227, 206, 156, 73, 235, 168, 187, 25, 254, 192, 242, 73, 232, 239, 212, 199, 183, 173, 241, 179, 28, 195, 238, 55, 82, 214, 255, 171, 13, 63, 98, 205, 144, 34, 117, 157, 226, 188, 59, 156, 106, 112, 173, 245, 76, 31, 86, 223, 165, 182, 39, 106, 87, 221, 66, 253, 99, 29, 2, 85, 201, 106, 245, 75, 234, 252, 105, 174, 253, 181, 138, 115, 238, 83, 119, 105, 75, 195, 7, 4, 117, 93, 99, 69, 88, 254, 124, 198, 212, 151, 76, 115, 206, 235, 156, 188, 2, 175, 151, 135, 212, 131, 108, 199, 80, 171, 30, 105, 125, 82, 93, 141, 17, 245, 45, 53, 174, 251, 44, 167, 70, 47, 44, 115, 26, 65, 204, 84, 71, 93, 226, 100, 173, 165, 250, 95, 213, 4, 64, 221, 192, 208, 84, 205, 114, 147, 13, 152, 128, 170, 134, 162, 24, 33, 42, 111, 103, 242, 252, 167, 17, 134, 137, 196, 135, 115, 42, 174, 251, 56, 224, 115, 76, 141, 95, 223, 22, 184, 90, 93, 9, 180, 111, 44, 159, 221, 12, 1, 143, 99, 234, 28, 105, 79, 96, 49, 240, 189, 138, 207, 119, 6, 90, 153, 106, 252, 35, 240, 20, 224, 247, 245, 28, 92, 43, 198, 105, 1, 240, 52, 90, 139, 137, 175, 54, 214, 255, 43, 240, 162, 42, 215, 29, 6, 254, 169, 133, 123, 101, 38, 88, 0, 188, 79, 189, 40, 165, 180, 170, 236, 243, 13, 104, 45, 187, 105, 24, 216, 184, 145, 131, 171, 241, 48, 145, 176, 176, 43, 205, 11, 87, 181, 140, 146, 81, 96, 41, 33, 116, 125, 179, 52, 158, 101, 140, 1, 55, 82, 189, 255, 91, 97, 132, 200, 121, 108, 13, 117, 177, 177, 34, 104, 134, 49, 245, 189, 173, 255, 150, 76, 187, 80, 119, 119, 234, 124, 172, 17, 174, 52, 210, 241, 234, 162, 166, 214, 48, 130, 235, 142, 4, 78, 160, 1, 21, 72, 188, 41, 87, 3, 123, 165, 148, 238, 45, 187, 222, 122, 192, 250, 13, 92, 39, 211, 26, 163, 192, 242, 146, 253, 201, 48, 67, 156, 13, 44, 161, 246, 72, 85, 139, 91, 129, 183, 167, 148, 126, 218, 182, 214, 169, 187, 168, 191, 44, 164, 125, 180, 226, 79, 181, 101, 235, 31, 212, 103, 84, 185, 206, 153, 54, 191, 202, 204, 52, 198, 184, 97, 86, 120, 110, 197, 51, 216, 72, 253, 161, 147, 35, 73, 74, 199, 143, 59, 245, 249, 174, 50, 34, 42, 58, 227, 187, 85, 135, 213, 13, 141, 204, 145, 77, 212, 205, 140, 24, 170, 143, 58, 17, 156, 55, 174, 254, 73, 221, 185, 56, 103, 61, 245, 24, 67, 5, 167, 226, 156, 83, 157, 28, 204, 151, 105, 63, 227, 70, 108, 219, 155, 140, 231, 54, 87, 221, 83, 253, 135, 226, 185, 108, 172, 94, 224, 196, 75, 62, 174, 222, 101, 248, 109, 159, 172, 110, 234, 196, 115, 94, 223, 94, 184, 137, 12, 97, 185, 171, 104, 220, 53, 22, 111, 136, 17, 241, 248, 77, 67, 203, 221, 102, 204, 215, 134, 212, 5, 70, 112, 218, 67, 157, 237, 219, 129, 101, 212, 240, 183, 190, 220, 120, 153, 231, 169, 199, 26, 218, 235, 10, 139, 132, 87, 227, 249, 124, 199, 208, 92, 35, 134, 2, 232, 159, 197, 84, 209, 248, 75, 212, 59, 213, 29, 139, 207, 22, 169, 23, 58, 161, 110, 199, 213, 149, 234, 171, 203, 206, 251, 176, 97, 161, 207, 180, 143, 81, 245, 23, 234, 102, 101, 253, 252, 94, 99, 132, 40, 13, 117, 215, 171, 79, 41, 190, 219, 80, 189, 216, 200, 43, 232, 191, 216, 55, 117, 123, 245, 0, 67, 200, 146, 250, 89, 67, 104, 202, 231, 95, 227, 134, 230, 90, 82, 28, 179, 192, 240, 198, 175, 236, 116, 111, 15, 8, 163, 234, 247, 213, 205, 139, 103, 50, 95, 125, 183, 145, 42, 86, 206, 152, 122, 173, 186, 125, 113, 220, 34, 139, 33, 178, 111, 49, 134, 186, 233, 76, 20, 227, 70, 218, 252, 171, 139, 99, 135, 12, 65, 187, 198, 169, 147, 201, 76, 253, 140, 26, 9, 189, 37, 161, 122, 146, 122, 142, 250, 136, 213, 23, 87, 227, 134, 233, 96, 237, 168, 3, 161, 190, 204, 169, 62, 192, 106, 172, 176, 44, 226, 81, 221, 198, 136, 108, 104, 212, 49, 154, 137, 23, 242, 231, 234, 198, 69, 95, 110, 97, 248, 93, 235, 225, 247, 234, 22, 189, 147, 152, 58, 48, 50, 72, 110, 182, 126, 225, 184, 195, 152, 103, 45, 44, 206, 127, 174, 122, 149, 89, 115, 53, 194, 152, 147, 53, 213, 179, 141, 9, 122, 189, 125, 88, 10, 85, 218, 190, 183, 210, 83, 5, 99, 190, 180, 187, 83, 67, 101, 235, 97, 196, 8, 251, 120, 98, 113, 173, 167, 170, 75, 27, 232, 152, 65, 102, 212, 88, 213, 149, 132, 234, 233, 234, 229, 54, 167, 245, 47, 43, 93, 167, 157, 180, 90, 104, 99, 27, 224, 2, 160, 153, 196, 201, 97, 96, 95, 96, 158, 250, 250, 148, 210, 77, 234, 190, 192, 87, 128, 189, 152, 92, 108, 173, 151, 60, 2, 220, 14, 220, 68, 20, 125, 235, 37, 165, 50, 146, 75, 129, 175, 166, 148, 30, 45, 62, 127, 60, 17, 117, 112, 27, 141, 249, 96, 5, 30, 32, 60, 43, 119, 183, 177, 157, 205, 99, 104, 171, 79, 219, 186, 134, 25, 49, 204, 19, 155, 21, 215, 93, 164, 30, 103, 164, 57, 245, 146, 135, 212, 115, 213, 93, 109, 192, 71, 150, 9, 154, 54, 138, 169, 219, 0, 87, 48, 181, 172, 97, 51, 140, 2, 255, 3, 188, 7, 88, 86, 124, 246, 110, 194, 79, 185, 62, 221, 143, 132, 88, 81, 220, 251, 12, 96, 51, 34, 190, 105, 11, 154, 143, 79, 91, 219, 25, 7, 254, 6, 252, 22, 184, 58, 165, 180, 186, 99, 119, 50, 50, 69, 218, 205, 253, 234, 27, 156, 176, 137, 29, 97, 111, 92, 64, 215, 25, 86, 235, 173, 13, 223, 103, 94, 177, 6, 227, 234, 59, 234, 145, 143, 105, 53, 129, 177, 106, 123, 30, 176, 29, 81, 87, 189, 196, 16, 49, 15, 170, 25, 95, 221, 2, 247, 16, 218, 226, 156, 162, 125, 59, 18, 65, 135, 221, 42, 188, 38, 112, 123, 74, 233, 98, 245, 27, 68, 112, 226, 28, 34, 242, 117, 25, 131, 25, 225, 186, 46, 240, 102, 34, 10, 245, 47, 41, 165, 173, 27, 190, 130, 145, 201, 241, 26, 99, 41, 123, 183, 221, 215, 24, 165, 204, 144, 131, 213, 185, 51, 183, 184, 115, 24, 198, 219, 18, 47, 236, 101, 91, 122, 141, 122, 90, 209, 15, 247, 91, 71, 66, 241, 36, 45, 96, 248, 140, 62, 5, 28, 204, 100, 13, 213, 77, 18, 176, 30, 240, 159, 192, 118, 234, 87, 128, 251, 233, 158, 166, 88, 145, 82, 90, 89, 252, 187, 60, 148, 119, 16, 53, 85, 57, 99, 197, 223, 117, 205, 119, 215, 8, 150, 186, 8, 248, 56, 240, 111, 180, 54, 236, 252, 17, 184, 139, 24, 190, 182, 168, 183, 33, 85, 88, 64, 212, 121, 175, 107, 76, 111, 35, 171, 213, 151, 165, 148, 150, 118, 249, 190, 179, 138, 97, 8, 63, 31, 240, 81, 224, 80, 194, 126, 52, 2, 252, 9, 56, 159, 88, 249, 173, 170, 56, 111, 8, 120, 19, 33, 132, 149, 124, 18, 248, 42, 240, 36, 224, 104, 224, 0, 38, 4, 172, 17, 33, 43, 29, 63, 135, 152, 247, 116, 107, 87, 134, 117, 232, 157, 182, 158, 53, 148, 52, 211, 129, 192, 225, 68, 167, 10, 252, 8, 120, 107, 74, 233, 239, 181, 78, 180, 182, 19, 211, 98, 107, 142, 155, 129, 227, 212, 143, 17, 2, 118, 12, 176, 136, 16, 202, 70, 181, 216, 197, 68, 58, 254, 138, 6, 207, 107, 134, 7, 128, 59, 186, 112, 159, 89, 205, 176, 97, 152, 124, 15, 33, 84, 99, 192, 207, 129, 119, 76, 39, 84, 5, 155, 214, 248, 124, 203, 242, 255, 164, 148, 238, 7, 62, 162, 158, 14, 188, 16, 120, 61, 81, 51, 96, 81, 113, 207, 122, 132, 108, 28, 184, 49, 165, 180, 188, 142, 99, 51, 125, 192, 48, 81, 88, 226, 105, 197, 255, 239, 1, 142, 73, 41, 221, 62, 221, 73, 70, 96, 254, 11, 106, 124, 189, 135, 250, 241, 202, 34, 18, 41, 165, 191, 1, 63, 0, 74, 133, 194, 118, 34, 76, 22, 219, 21, 255, 222, 136, 218, 67, 208, 75, 128, 143, 171, 71, 165, 148, 86, 171, 219, 2, 95, 39, 92, 73, 237, 54, 158, 62, 64, 20, 39, 185, 170, 205, 215, 237, 27, 140, 130, 193, 31, 32, 204, 7, 165, 21, 222, 106, 194, 157, 118, 74, 74, 105, 172, 214, 185, 141, 220, 228, 93, 78, 24, 0, 127, 236, 12, 197, 31, 140, 56, 170, 227, 157, 92, 70, 167, 156, 149, 54, 88, 190, 208, 72, 255, 62, 213, 136, 33, 170, 197, 106, 245, 240, 226, 248, 249, 134, 57, 164, 83, 188, 178, 184, 207, 181, 101, 159, 237, 220, 124, 47, 247, 15, 70, 205, 135, 90, 161, 53, 15, 90, 195, 33, 109, 60, 31, 141, 253, 141, 234, 50, 55, 148, 107, 137, 229, 117, 72, 235, 94, 192, 241, 84, 207, 116, 134, 48, 166, 29, 162, 30, 91, 111, 233, 155, 148, 210, 131, 234, 251, 129, 95, 3, 31, 3, 158, 69, 245, 108, 233, 15, 168, 191, 79, 41, 253, 74, 61, 150, 112, 130, 119, 98, 11, 144, 254, 137, 255, 110, 35, 70, 10, 222, 39, 136, 126, 187, 142, 48, 248, 142, 17, 243, 234, 17, 224, 199, 132, 235, 166, 45, 55, 59, 222, 9, 141, 117, 246, 12, 199, 46, 114, 106, 105, 199, 106, 220, 166, 62, 109, 186, 107, 77, 115, 143, 29, 13, 151, 74, 45, 231, 246, 101, 22, 229, 142, 212, 151, 218, 88, 28, 88, 189, 236, 83, 92, 127, 214, 104, 44, 99, 215, 143, 147, 141, 64, 203, 179, 44, 130, 3, 27, 56, 191, 33, 141, 213, 168, 83, 117, 31, 98, 62, 52, 19, 91, 0, 103, 217, 68, 144, 126, 49, 183, 121, 51, 176, 178, 198, 33, 59, 0, 255, 161, 206, 77, 41, 93, 12, 156, 200, 132, 241, 46, 83, 155, 147, 128, 227, 128, 239, 18, 243, 232, 25, 11, 180, 181, 66, 163, 130, 181, 103, 3, 215, 221, 5, 120, 155, 77, 164, 21, 165, 148, 174, 33, 124, 115, 163, 85, 190, 30, 38, 170, 11, 158, 108, 184, 124, 46, 4, 206, 34, 38, 159, 179, 30, 99, 63, 195, 51, 212, 221, 234, 60, 126, 161, 122, 50, 225, 77, 57, 143, 88, 241, 215, 122, 105, 219, 70, 163, 130, 181, 128, 250, 231, 31, 67, 192, 251, 129, 215, 214, 163, 58, 171, 112, 38, 81, 156, 164, 154, 97, 116, 62, 177, 157, 237, 62, 69, 39, 149, 222, 196, 89, 237, 118, 81, 119, 2, 206, 5, 222, 6, 156, 173, 78, 251, 162, 27, 171, 239, 247, 1, 239, 2, 254, 23, 120, 79, 74, 233, 193, 142, 55, 148, 198, 5, 171, 81, 237, 243, 120, 224, 116, 96, 113, 163, 154, 43, 165, 116, 11, 83, 107, 60, 149, 51, 12, 124, 74, 221, 161, 40, 215, 115, 60, 97, 216, 92, 107, 246, 77, 110, 4, 35, 31, 240, 60, 98, 97, 51, 135, 168, 85, 117, 198, 12, 115, 165, 143, 16, 253, 178, 10, 120, 111, 29, 182, 201, 182, 209, 141, 192, 181, 13, 137, 128, 185, 3, 109, 188, 142, 229, 178, 25, 190, 223, 10, 248, 162, 186, 105, 74, 233, 175, 68, 177, 184, 123, 104, 77, 184, 164, 205, 115, 54, 117, 239, 98, 242, 251, 207, 205, 104, 239, 66, 83, 125, 159, 88, 193, 31, 14, 236, 65, 12, 255, 91, 2, 159, 87, 55, 170, 56, 190, 52, 252, 189, 157, 8, 171, 126, 3, 117, 22, 76, 107, 23, 221, 136, 113, 74, 132, 33, 243, 51, 192, 110, 70, 140, 211, 205, 192, 157, 41, 165, 145, 90, 39, 25, 213, 110, 102, 42, 70, 145, 136, 201, 252, 41, 234, 59, 129, 139, 136, 106, 42, 71, 19, 213, 238, 154, 49, 27, 172, 2, 254, 220, 196, 121, 83, 40, 230, 128, 75, 128, 79, 19, 145, 168, 71, 2, 167, 170, 95, 44, 175, 196, 51, 195, 53, 118, 34, 132, 104, 35, 224, 208, 148, 210, 79, 138, 207, 175, 36, 226, 241, 15, 1, 238, 81, 79, 44, 204, 54, 235, 17, 195, 223, 113, 196, 75, 118, 116, 233, 156, 110, 210, 205, 93, 75, 55, 34, 58, 225, 16, 138, 135, 167, 254, 31, 209, 57, 149, 204, 35, 188, 1, 245, 84, 57, 25, 34, 156, 225, 203, 129, 19, 138, 168, 132, 126, 137, 76, 120, 61, 49, 21, 152, 75, 248, 57, 135, 8, 159, 231, 126, 234, 146, 98, 184, 175, 73, 49, 252, 125, 13, 88, 8, 44, 73, 41, 93, 86, 250, 46, 165, 180, 82, 61, 17, 120, 49, 33, 176, 155, 169, 159, 4, 14, 3, 14, 34, 86, 213, 111, 75, 41, 253, 188, 221, 63, 170, 30, 122, 181, 29, 238, 124, 224, 153, 197, 159, 118, 48, 135, 232, 220, 103, 170, 215, 19, 198, 190, 102, 121, 8, 56, 55, 165, 116, 87, 43, 13, 82, 15, 2, 78, 33, 180, 230, 7, 9, 23, 212, 34, 66, 176, 22, 3, 63, 86, 63, 1, 124, 163, 90, 12, 121, 161, 169, 190, 76, 8, 229, 33, 68, 133, 197, 73, 20, 26, 106, 9, 225, 42, 219, 31, 120, 85, 113, 252, 29, 192, 17, 68, 30, 65, 111, 176, 49, 3, 233, 55, 154, 179, 55, 174, 117, 236, 85, 252, 222, 134, 13, 164, 70, 4, 238, 27, 141, 232, 219, 219, 140, 93, 99, 231, 150, 125, 191, 158, 177, 173, 203, 237, 134, 177, 242, 203, 70, 249, 160, 84, 118, 204, 78, 134, 219, 229, 118, 245, 21, 117, 220, 115, 79, 39, 246, 51, 188, 197, 72, 163, 107, 43, 118, 216, 64, 58, 40, 52, 85, 4, 214, 152, 23, 158, 4, 124, 137, 200, 67, 220, 35, 165, 244, 197, 242, 185, 100, 74, 105, 69, 74, 233, 67, 132, 19, 127, 25, 177, 235, 199, 111, 136, 162, 191, 37, 7, 241, 121, 196, 28, 241, 53, 41, 165, 139, 102, 186, 111, 74, 233, 18, 66, 99, 253, 4, 120, 109, 74, 233, 135, 205, 180, 191, 157, 116, 74, 176, 74, 129, 121, 15, 2, 215, 179, 118, 217, 151, 154, 90, 21, 26, 206, 219, 239, 16, 246, 181, 171, 128, 131, 83, 74, 53, 23, 1, 69, 4, 201, 254, 68, 249, 198, 77, 128, 11, 213, 101, 192, 207, 8, 193, 62, 132, 8, 178, 172, 139, 148, 210, 117, 192, 126, 41, 165, 41, 67, 102, 47, 232, 212, 28, 235, 65, 98, 37, 115, 14, 97, 203, 250, 22, 205, 101, 75, 215, 67, 105, 207, 151, 155, 136, 249, 81, 171, 118, 172, 135, 105, 112, 105, 174, 110, 77, 204, 135, 118, 1, 46, 37, 132, 106, 218, 208, 35, 128, 148, 210, 221, 234, 113, 196, 156, 232, 80, 98, 206, 121, 39, 112, 100, 51, 245, 62, 83, 74, 213, 60, 21, 61, 161, 83, 130, 181, 20, 56, 62, 165, 52, 166, 190, 148, 198, 138, 227, 54, 130, 68, 225, 213, 215, 149, 175, 152, 186, 137, 250, 4, 194, 26, 190, 35, 161, 177, 14, 75, 41, 61, 84, 239, 249, 197, 177, 31, 82, 207, 3, 222, 72, 44, 28, 254, 210, 145, 198, 118, 145, 78, 8, 214, 106, 224, 155, 101, 225, 55, 149, 187, 80, 180, 147, 27, 137, 106, 190, 151, 193, 154, 93, 177, 90, 29, 222, 199, 139, 208, 234, 122, 249, 12, 176, 53, 17, 122, 253, 245, 148, 82, 83, 225, 211, 41, 165, 27, 137, 21, 227, 172, 160, 83, 130, 245, 155, 178, 255, 95, 64, 36, 94, 108, 69, 251, 226, 156, 4, 254, 74, 8, 213, 165, 70, 20, 197, 113, 132, 201, 161, 213, 178, 135, 143, 168, 251, 166, 148, 174, 156, 177, 17, 177, 58, 154, 71, 24, 100, 191, 211, 160, 64, 206, 106, 58, 33, 88, 67, 196, 188, 234, 102, 136, 73, 165, 186, 24, 248, 33, 208, 174, 178, 132, 183, 0, 139, 83, 74, 215, 26, 150, 230, 47, 16, 198, 200, 118, 252, 158, 245, 169, 115, 207, 153, 34, 144, 113, 191, 54, 220, 115, 214, 209, 137, 85, 225, 60, 224, 200, 114, 219, 77, 74, 105, 25, 240, 106, 34, 196, 101, 21, 19, 81, 139, 205, 112, 35, 49, 57, 190, 86, 221, 0, 56, 141, 72, 131, 111, 231, 75, 50, 43, 35, 72, 187, 73, 39, 4, 107, 14, 97, 1, 62, 70, 93, 179, 19, 69, 17, 192, 183, 4, 120, 34, 176, 61, 177, 122, 106, 68, 184, 36, 220, 20, 199, 20, 195, 223, 186, 196, 238, 159, 7, 211, 63, 181, 180, 50, 5, 157, 178, 99, 173, 79, 100, 85, 95, 101, 236, 232, 185, 65, 217, 196, 122, 43, 224, 67, 64, 163, 197, 85, 71, 137, 100, 216, 139, 138, 185, 205, 73, 192, 91, 201, 201, 165, 125, 73, 39, 125, 133, 115, 9, 39, 242, 231, 136, 225, 106, 140, 24, 98, 230, 17, 26, 166, 17, 161, 30, 33, 178, 171, 79, 75, 41, 169, 238, 77, 132, 143, 116, 170, 253, 165, 161, 208, 42, 159, 13, 42, 13, 253, 254, 110, 56, 161, 231, 210, 154, 86, 25, 37, 12, 173, 255, 94, 120, 244, 119, 39, 194, 80, 22, 182, 163, 113, 53, 40, 237, 246, 90, 30, 194, 187, 185, 177, 145, 231, 32, 174, 252, 74, 155, 110, 66, 120, 81, 102, 236, 131, 94, 69, 55, 212, 203, 8, 97, 181, 63, 38, 165, 244, 136, 81, 69, 240, 108, 162, 46, 68, 39, 217, 182, 248, 251, 155, 132, 225, 115, 29, 194, 248, 57, 200, 148, 52, 214, 13, 245, 152, 85, 250, 65, 176, 238, 34, 38, 242, 127, 101, 178, 79, 113, 53, 112, 45, 240, 211, 148, 82, 41, 102, 107, 62, 49, 36, 118, 178, 38, 232, 40, 240, 203, 226, 223, 103, 17, 67, 247, 251, 137, 144, 151, 65, 230, 97, 224, 23, 68, 86, 212, 140, 244, 131, 96, 157, 71, 196, 99, 207, 248, 22, 164, 148, 174, 37, 132, 173, 43, 20, 177, 244, 167, 169, 159, 39, 22, 36, 131, 26, 13, 50, 206, 228, 186, 97, 51, 210, 15, 130, 117, 77, 63, 90, 172, 11, 115, 198, 198, 68, 8, 245, 42, 166, 150, 114, 26, 72, 138, 248, 176, 245, 83, 74, 231, 79, 119, 92, 63, 8, 86, 223, 133, 212, 20, 66, 117, 62, 145, 71, 121, 141, 250, 39, 122, 95, 227, 189, 215, 172, 11, 60, 153, 72, 88, 254, 155, 122, 105, 81, 232, 165, 42, 253, 32, 88, 253, 200, 14, 192, 203, 136, 249, 213, 174, 197, 159, 204, 4, 235, 18, 113, 245, 167, 214, 58, 96, 80, 231, 12, 51, 113, 0, 217, 154, 63, 29, 195, 192, 97, 133, 159, 182, 230, 1, 141, 208, 137, 185, 80, 95, 205, 175, 138, 248, 170, 189, 203, 63, 162, 122, 170, 255, 32, 50, 204, 132, 217, 97, 75, 96, 55, 34, 28, 186, 234, 129, 141, 112, 39, 209, 209, 237, 12, 127, 105, 37, 163, 166, 19, 188, 129, 240, 24, 148, 126, 227, 195, 68, 225, 183, 91, 233, 191, 182, 118, 139, 33, 162, 222, 255, 247, 152, 48, 245, 204, 37, 250, 170, 122, 206, 162, 141, 101, 233, 236, 236, 244, 197, 209, 26, 229, 81, 171, 236, 120, 223, 75, 156, 92, 219, 93, 245, 87, 246, 184, 222, 124, 63, 96, 20, 108, 187, 188, 162, 111, 110, 181, 70, 161, 182, 70, 231, 88, 87, 16, 57, 114, 237, 88, 122, 143, 16, 174, 154, 182, 100, 29, 183, 3, 245, 249, 64, 185, 160, 143, 3, 87, 147, 135, 66, 138, 157, 198, 190, 207, 228, 85, 252, 19, 129, 195, 173, 86, 151, 163, 17, 141, 85, 28, 63, 79, 61, 218, 216, 163, 112, 180, 73, 77, 117, 159, 177, 119, 116, 205, 201, 95, 183, 49, 242, 1, 47, 112, 114, 193, 183, 71, 141, 196, 209, 12, 160, 110, 162, 46, 175, 120, 150, 55, 89, 22, 30, 85, 162, 97, 115, 67, 74, 233, 49, 224, 179, 234, 25, 68, 113, 212, 39, 80, 191, 230, 27, 39, 28, 187, 75, 83, 74, 15, 52, 122, 239, 14, 179, 13, 97, 98, 40, 255, 45, 215, 19, 169, 92, 25, 32, 165, 180, 92, 189, 26, 120, 105, 217, 199, 79, 6, 94, 65, 216, 253, 214, 48, 204, 228, 85, 89, 221, 137, 154, 69, 90, 248, 175, 90, 104, 103, 191, 177, 59, 177, 213, 74, 57, 151, 214, 91, 71, 117, 128, 88, 198, 100, 193, 74, 192, 81, 234, 127, 151, 187, 124, 134, 153, 92, 148, 99, 75, 163, 4, 227, 64, 173, 126, 140, 50, 64, 71, 49, 117, 181, 187, 153, 186, 7, 125, 232, 29, 232, 17, 115, 152, 154, 15, 144, 136, 124, 202, 231, 80, 150, 68, 51, 204, 196, 228, 116, 46, 97, 174, 223, 153, 168, 94, 60, 72, 188, 149, 168, 110, 83, 41, 88, 7, 22, 127, 50, 211, 51, 68, 108, 195, 188, 70, 176, 230, 16, 101, 153, 75, 201, 158, 11, 128, 47, 24, 245, 3, 6, 137, 125, 104, 178, 94, 67, 102, 13, 251, 171, 107, 118, 43, 73, 0, 234, 139, 8, 227, 215, 166, 196, 156, 235, 10, 98, 235, 220, 223, 246, 83, 218, 118, 39, 48, 236, 104, 75, 233, 108, 98, 109, 57, 247, 18, 53, 175, 46, 103, 178, 99, 123, 156, 168, 161, 53, 159, 201, 22, 238, 102, 152, 71, 12, 77, 7, 16, 201, 180, 221, 8, 171, 30, 37, 74, 3, 156, 73, 249, 13, 213, 35, 136, 100, 133, 249, 197, 231, 171, 8, 77, 118, 49, 81, 19, 97, 182, 145, 128, 205, 9, 103, 234, 19, 186, 116, 79, 129, 147, 82, 74, 31, 238, 202, 205, 116, 127, 224, 219, 116, 79, 27, 255, 136, 200, 247, 28, 43, 23, 172, 117, 136, 154, 149, 39, 19, 171, 163, 65, 79, 30, 232, 4, 43, 137, 210, 70, 51, 102, 89, 183, 3, 163, 240, 237, 239, 8, 191, 94, 55, 158, 231, 253, 196, 239, 187, 110, 210, 205, 212, 97, 194, 150, 115, 2, 19, 177, 222, 89, 192, 218, 203, 45, 68, 53, 158, 78, 175, 52, 19, 176, 1, 145, 31, 208, 173, 103, 56, 14, 92, 2, 236, 93, 245, 134, 133, 137, 126, 119, 162, 220, 224, 34, 102, 95, 120, 77, 34, 230, 147, 207, 102, 246, 253, 182, 94, 51, 6, 236, 48, 176, 218, 72, 125, 42, 17, 63, 63, 127, 166, 99, 51, 13, 33, 176, 239, 192, 10, 22, 196, 134, 80, 68, 153, 236, 129, 238, 135, 54, 179, 154, 9, 243, 85, 38, 211, 94, 6, 246, 77, 45, 60, 242, 139, 105, 189, 158, 86, 102, 50, 99, 192, 47, 7, 89, 176, 158, 65, 36, 96, 110, 206, 0, 191, 96, 109, 70, 224, 239, 192, 107, 6, 186, 67, 213, 167, 19, 213, 248, 54, 37, 187, 116, 90, 101, 156, 216, 98, 229, 179, 68, 13, 179, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 38, 147, 201, 100, 50, 153, 76, 166, 121, 254, 31, 28, 0, 251, 208, 5, 239, 182, 83, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130 }, "Diagnostics" }
                });

            migrationBuilder.InsertData(
                table: "StoreItemCategory",
                columns: new[] { "Id", "Name" },
                values: new object[] { 1, "Brakes" });

            migrationBuilder.InsertData(
                table: "CarModels",
                columns: new[] { "Id", "CarManufacturerId", "ModelYear", "Name" },
                values: new object[,]
                {
                    { 1, 1, "1997-2003", "Golf Mk4" },
                    { 2, 1, "1999-2006", "Bora" },
                    { 3, 1, "1997-2000", "Passat B5" },
                    { 4, 1, "2000-2005", "Passat B5.5" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "Address", "CityId", "Created", "Email", "Gender", "Image", "Name", "PasswordHash", "PasswordSalt", "Phone", "PostalCode", "RoleId", "Surname", "Username" },
                values: new object[,]
                {
                    { 1, "Goricka 71", 1, new DateTime(2024, 8, 19, 0, 0, 0, 0, DateTimeKind.Local), "esrefpivcic@gmail.com", "Male", null, "Esref", "UIbt4z2jkoankICVyOXToRDh4BA=", "zNe9iIIlYswkP+yjd0UCNw==", "063111222", "80101", 1, "Pivcic", "admin" },
                    { 2, "Goricka 71", 1, new DateTime(2024, 8, 19, 0, 0, 0, 0, DateTimeKind.Local), "esrefpivcic@gmail.com", "Male", null, "Esref", "fNPIUGyBfY/NOU0fcyr4oZCUoHU=", "KvlznVyWZ9ejkgcmvMQ/3A==", "063111222", "80101", 4, "Pivcic", "carpartsshop" },
                    { 3, "Goricka 71", 1, new DateTime(2024, 8, 19, 0, 0, 0, 0, DateTimeKind.Local), "esrefpivcic@gmail.com", "Male", null, "Esref", "z2p3YCCdcZtsNi14UrQ/VTDls7Y=", "KvlznVyWZ9ejkgcmvMQ/3A==", "063111222", "80101", 3, "Pivcic", "carrepairshop" },
                    { 4, "Goricka 71", 1, new DateTime(2024, 8, 19, 0, 0, 0, 0, DateTimeKind.Local), "esrefpivcic@gmail.com", "Male", null, "Esref", "LQ7aBJ4qiUgMfTp8OKRAksTCBbw=", "KvlznVyWZ9ejkgcmvMQ/3A==", "063111222", "80101", 2, "Pivcic", "client" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AuthTokens_UserId",
                table: "AuthTokens",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_CarModels_CarManufacturerId",
                table: "CarModels",
                column: "CarManufacturerId");

            migrationBuilder.CreateIndex(
                name: "IX_CarPartsShopClientDiscounts_CarPartsShopId",
                table: "CarPartsShopClientDiscounts",
                column: "CarPartsShopId");

            migrationBuilder.CreateIndex(
                name: "IX_CarPartsShopClientDiscounts_CarRepairShopId",
                table: "CarPartsShopClientDiscounts",
                column: "CarRepairShopId");

            migrationBuilder.CreateIndex(
                name: "IX_CarPartsShopClientDiscounts_ClientId",
                table: "CarPartsShopClientDiscounts",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_CarRepairShopDiscounts_CarRepairShopId",
                table: "CarRepairShopDiscounts",
                column: "CarRepairShopId");

            migrationBuilder.CreateIndex(
                name: "IX_CarRepairShopDiscounts_ClientId",
                table: "CarRepairShopDiscounts",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_CarRepairShopServices_CarRepairShopId",
                table: "CarRepairShopServices",
                column: "CarRepairShopId");

            migrationBuilder.CreateIndex(
                name: "IX_CarRepairShopServices_ServiceTypeId",
                table: "CarRepairShopServices",
                column: "ServiceTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderDetails_OrderId",
                table: "OrderDetails",
                column: "OrderId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderDetails_StoreItemId",
                table: "OrderDetails",
                column: "StoreItemId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_CarPartsShopId",
                table: "Orders",
                column: "CarPartsShopId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_CarRepairShopId",
                table: "Orders",
                column: "CarRepairShopId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_CityId",
                table: "Orders",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_ClientDiscountId",
                table: "Orders",
                column: "ClientDiscountId");

            migrationBuilder.CreateIndex(
                name: "IX_Orders_ClientId",
                table: "Orders",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_StoreItemCarModels_CarModelId",
                table: "StoreItemCarModels",
                column: "CarModelId");

            migrationBuilder.CreateIndex(
                name: "IX_StoreItems_CarPartsShopId",
                table: "StoreItems",
                column: "CarPartsShopId");

            migrationBuilder.CreateIndex(
                name: "IX_StoreItems_StoreItemCategoryId",
                table: "StoreItems",
                column: "StoreItemCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_CityId",
                table: "Users",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_RoleId",
                table: "Users",
                column: "RoleId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AuthTokens");

            migrationBuilder.DropTable(
                name: "CarRepairShopDiscounts");

            migrationBuilder.DropTable(
                name: "CarRepairShopServices");

            migrationBuilder.DropTable(
                name: "OrderDetails");

            migrationBuilder.DropTable(
                name: "StoreItemCarModels");

            migrationBuilder.DropTable(
                name: "ServiceTypes");

            migrationBuilder.DropTable(
                name: "Orders");

            migrationBuilder.DropTable(
                name: "CarModels");

            migrationBuilder.DropTable(
                name: "StoreItems");

            migrationBuilder.DropTable(
                name: "CarPartsShopClientDiscounts");

            migrationBuilder.DropTable(
                name: "CarManufacturers");

            migrationBuilder.DropTable(
                name: "StoreItemCategory");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Roles");
        }
    }
}
