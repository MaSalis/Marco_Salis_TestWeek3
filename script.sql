USE [master]
GO
/****** Object:  Database [Pizzeria]    Script Date: 12/17/2021 3:24:19 PM ******/
CREATE DATABASE [Pizzeria]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Pizzeria', FILENAME = N'C:\Users\marco.salis\Pizzeria.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Pizzeria_log', FILENAME = N'C:\Users\marco.salis\Pizzeria_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Pizzeria] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Pizzeria].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Pizzeria] SET ARITHABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Pizzeria] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Pizzeria] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Pizzeria] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Pizzeria] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Pizzeria] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Pizzeria] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Pizzeria] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Pizzeria] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Pizzeria] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Pizzeria] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Pizzeria] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET  MULTI_USER 
GO
ALTER DATABASE [Pizzeria] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Pizzeria] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Pizzeria] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Pizzeria] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Pizzeria] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Pizzeria] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Pizzeria] SET QUERY_STORE = OFF
GO
USE [Pizzeria]
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroIngredientiNellaPizza]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroIngredientiNellaPizza] (@NomePizza varchar(50))
returns int 
as 
BEGIN
declare @IdPizza int
select @IdPizza = p.CodicePizza from Pizza p where p.Nome = @NomePizza

declare @NumIngredienti int	

select @NumIngredienti = count(m.CodPizza)
from Pizza p join Menu m on p.CodicePizza = m.CodPizza
where m.CodPizza = @IdPizza
--group by p.Nome
return @NumIngredienti

END
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroPizzeConIngrediente]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroPizzeConIngrediente] (@NomeIngrediente varchar(50))
returns int
as 
begin
declare @NumeroPizze int
select @NumeroPizze = count(p.Nome) 
from Pizza p join Menu m on p.CodicePizza = m.CodPizza
			join Ingrediente i on m.CodIngrediente = i.CodiceIngrediente
where i.Nome = @NomeIngrediente
return @NumeroPizze
end
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroPizzeSenzaIngrediente]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ingrediente)
create function [dbo].[NumeroPizzeSenzaIngrediente] (@CodiceIngrediente int)
returns int
as 
begin
declare @NumeroPizze int


select @NumeroPizze = count(p.Nome) 
from Pizza p 
where p.Nome not in (select p2.Nome
					from Pizza p2 join Menu m on p2.CodicePizza = m.CodPizza
								
					where m.CodIngrediente = @CodiceIngrediente )
return @NumeroPizze
end
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[CodicePizza] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NOT NULL,
	[Prezzo] [decimal](3, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodicePizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizze]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizze] ()
returns table 
as 
return
select Nome, Prezzo
from Pizza 
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[CodiceIngrediente] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NOT NULL,
	[Costo] [decimal](3, 2) NOT NULL,
	[QtaDisponibile] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodiceIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[CodPizza] [int] NOT NULL,
	[CodIngrediente] [int] NOT NULL,
 CONSTRAINT [PK_PizzaIngrediente] PRIMARY KEY CLUSTERED 
(
	[CodPizza] ASC,
	[CodIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeConIngrediente]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeConIngrediente] (@NomeIngrediente varchar(50))
returns table 
as 
return
select p.Nome, p.prezzo
from Pizza p join Menu m on p.CodicePizza = m.CodPizza
			join Ingrediente i on m.CodIngrediente = i.CodiceIngrediente
where i.Nome = @NomeIngrediente
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeSenzaIngrediente]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeSenzaIngrediente] (@NomeIngrediente varchar(50))
returns table 
as 
return


select distinct p.Nome, p.Prezzo
from Pizza p 
where p.Nome not in (select p.Nome
					from Pizza p join Menu m on p.CodicePizza = m.CodPizza
								join Ingrediente i on m.CodIngrediente = i.CodiceIngrediente
					where i.Nome = @NomeIngrediente)
GO
/****** Object:  View [dbo].[Menu Pizze]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Menu Pizze]
AS
select Nome, Prezzo
from Pizza
GO
SET IDENTITY_INSERT [dbo].[Ingrediente] ON 

INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (1, N'Pomodoro', CAST(1.00 AS Decimal(3, 2)), 50)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (2, N'Mozzarella', CAST(1.00 AS Decimal(3, 2)), 60)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (3, N'Mozzarella di bufala', CAST(2.50 AS Decimal(3, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (4, N'Spianata piccante', CAST(1.50 AS Decimal(3, 2)), 30)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (5, N'Funghi', CAST(1.00 AS Decimal(3, 2)), 50)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (6, N'Carciofi', CAST(1.50 AS Decimal(3, 2)), 40)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (7, N'Cotto', CAST(1.00 AS Decimal(3, 2)), 40)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (8, N'Olive', CAST(1.50 AS Decimal(3, 2)), 50)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (9, N'Funghi porcini', CAST(2.00 AS Decimal(3, 2)), 20)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (10, N'Stracchino', CAST(1.50 AS Decimal(3, 2)), 30)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (11, N'Speck', CAST(1.50 AS Decimal(3, 2)), 30)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (12, N'Rucola', CAST(1.00 AS Decimal(3, 2)), 40)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (13, N'Grana', CAST(1.50 AS Decimal(3, 2)), 45)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (14, N'Verdure di stagione', CAST(1.50 AS Decimal(3, 2)), 60)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (15, N'Patate', CAST(1.00 AS Decimal(3, 2)), 70)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (16, N'Salsiccia', CAST(2.00 AS Decimal(3, 2)), 50)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (17, N'Ricotta', CAST(1.50 AS Decimal(3, 2)), 30)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (18, N'Provola', CAST(1.50 AS Decimal(3, 2)), 40)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (19, N'Gorgonzola', CAST(1.50 AS Decimal(3, 2)), 40)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (20, N'Pomodoro fresco', CAST(1.50 AS Decimal(3, 2)), 30)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (21, N'Basilico', CAST(0.50 AS Decimal(3, 2)), 50)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (22, N'Bresaola', CAST(2.00 AS Decimal(3, 2)), 40)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QtaDisponibile]) VALUES (23, N'Pomodorini', CAST(1.50 AS Decimal(3, 2)), 40)
SET IDENTITY_INSERT [dbo].[Ingrediente] OFF
GO
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (1, 1)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (1, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (2, 1)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (2, 3)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (3, 1)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (3, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (3, 4)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (4, 1)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (4, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (4, 5)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (4, 6)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (4, 7)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (4, 8)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (5, 1)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (5, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (5, 9)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (6, 1)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (6, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (6, 10)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (6, 11)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (6, 12)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (6, 13)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (7, 1)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (7, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (7, 14)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (8, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (8, 15)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (8, 16)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (9, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (9, 17)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (9, 23)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (10, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (10, 13)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (10, 18)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (10, 19)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (11, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (11, 20)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (11, 21)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (12, 2)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (12, 12)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (12, 22)
INSERT [dbo].[Menu] ([CodPizza], [CodIngrediente]) VALUES (13, 1)
GO
SET IDENTITY_INSERT [dbo].[Pizza] ON 

INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (1, N'Margherita', CAST(5.00 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (2, N'Bufala', CAST(7.70 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (3, N'Diavola', CAST(6.00 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (4, N'Quatto stagioni', CAST(6.50 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (5, N'Porcini', CAST(7.00 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (6, N'Dioniso', CAST(8.00 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (7, N'Ortolana', CAST(8.00 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (8, N'Patate e salsiccia', CAST(6.00 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (9, N'Pomodorini', CAST(6.00 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (10, N'Quattro formaggi', CAST(7.50 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (11, N'Caprese', CAST(7.50 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (12, N'Zeus', CAST(7.50 AS Decimal(3, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (13, N'Canadese', CAST(7.00 AS Decimal(3, 2)))
SET IDENTITY_INSERT [dbo].[Pizza] OFF
GO
ALTER TABLE [dbo].[Menu]  WITH CHECK ADD FOREIGN KEY([CodIngrediente])
REFERENCES [dbo].[Ingrediente] ([CodiceIngrediente])
GO
ALTER TABLE [dbo].[Menu]  WITH CHECK ADD FOREIGN KEY([CodPizza])
REFERENCES [dbo].[Pizza] ([CodicePizza])
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD CHECK  (([Costo]>(0)))
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD CHECK  (([QtaDisponibile]>=(0)))
GO
ALTER TABLE [dbo].[Pizza]  WITH CHECK ADD CHECK  (([Prezzo]>(0)))
GO
/****** Object:  StoredProcedure [dbo].[AggiornaPrezzoPizza]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggiornaPrezzoPizza]
@NomePizza varchar(50),
@NuovoPrezzo decimal (3,2)
as 
update Pizza set Prezzo = @NuovoPrezzo where Nome = @NomePizza
GO
/****** Object:  StoredProcedure [dbo].[AggiungiIngredienteAPizza]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggiungiIngredienteAPizza]
@NomePizza varchar(50),
@NomeIngrediente varchar(50)
as 
declare @IdPizza int
declare @IdIngred int

select @IdPizza = p.CodicePizza
from Pizza p where p.Nome = @NomePizza

select @IdIngred = i.CodiceIngrediente
from Ingrediente i where i.Nome = @NomeIngrediente

insert into Menu values(@IdPizza, @IdIngred)
GO
/****** Object:  StoredProcedure [dbo].[AggiungiPizza]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggiungiPizza]
@Nome varchar(50),
@Prezzo decimal(3,2)
as 
insert into Pizza values (@Nome, @Prezzo)
GO
/****** Object:  StoredProcedure [dbo].[IncrementoPrezzoPizza]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[IncrementoPrezzoPizza]
@NomeIngrediente varchar(50)
as
--declare @IdIngred int
declare @IdPizza int

--select @IdIngred = i.CodiceIngrediente
--from Ingrediente i where i.Nome = @NomeIngrediente

select @IdPizza = m.CodPizza
from Menu m join Ingrediente i on m.CodIngrediente = i.CodiceIngrediente
where i.Nome = @NomeIngrediente

update Pizza set Prezzo += 0.1*Prezzo where CodicePizza = @IdPizza
GO
/****** Object:  StoredProcedure [dbo].[TogliIngredienteDaPizza]    Script Date: 12/17/2021 3:24:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[TogliIngredienteDaPizza]
@NomePizza varchar(50),
@NomeIngrediente varchar(50)
as 
declare @IdPizza int
declare @IdIngred int
select @IdPizza = p.CodicePizza
from Pizza p where p.Nome = @NomePizza

select @IdIngred = i.CodiceIngrediente
from Ingrediente i where i.Nome = @NomeIngrediente

delete from Menu where CodPizza = @IdPizza and CodIngrediente = @IdIngred  
GO
USE [master]
GO
ALTER DATABASE [Pizzeria] SET  READ_WRITE 
GO
