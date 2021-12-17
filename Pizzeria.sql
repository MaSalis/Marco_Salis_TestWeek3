create database Pizzeria

--drop table Pizza
create table Pizza(
CodicePizza int primary key identity(1,1),
Nome varchar(50) not null,
Prezzo decimal(3,2) not null check (Prezzo>0)
);

--drop table Ingrediente
create table Ingrediente (
CodiceIngrediente int primary key identity(1,1),
Nome varchar(50) not null,
Costo decimal(3,2) not null check (Costo >0),
QtaDisponibile int check (QtaDisponibile >=0)
);

--drop table Menu
create table Menu(
CodPizza int foreign key references Pizza(CodicePizza),
CodIngrediente int foreign key references Ingrediente(CodiceIngrediente),
constraint PK_PizzaIngrediente primary key (CodPizza, CodIngrediente)
);

--POPOLAMENTO DATABASE PIZZERIA

insert into Pizza values ('Margherita', 5)
insert into Pizza values ('Bufala', 7)
insert into Pizza values ('Diavola', 6)
insert into Pizza values ('Quatto stagioni', 6.50)
insert into Pizza values ('Porcini', 7)
insert into Pizza values ('Dioniso', 8)
insert into Pizza values ('Ortolana', 8)
insert into Pizza values ('Patate e salsiccia', 6)
insert into Pizza values ('Pomodorini', 6)
insert into Pizza values ('Quattro formaggi', 7.50)
insert into Pizza values ('Caprese', 7.50)
insert into Pizza values ('Zeus', 7.50)


insert into Ingrediente values ('Pomodoro', 1, 50)
insert into Ingrediente values ('Mozzarella', 1, 60)
insert into Ingrediente values ('Mozzarella di bufala', 2.5, 20) --3 
insert into Ingrediente values ('Spianata piccante', 1.5, 30)
insert into Ingrediente values ('Funghi', 1, 50)
insert into Ingrediente values ('Carciofi', 1.5, 40) --6
insert into Ingrediente values ('Cotto', 1, 40)
insert into Ingrediente values ('Olive', 1.5, 50)
insert into Ingrediente values ('Funghi porcini',2 , 20) --9
insert into Ingrediente values ('Stracchino', 1.5, 30)
insert into Ingrediente values ('Speck', 1.5, 30)
insert into Ingrediente values ('Rucola', 1, 40) --12
insert into Ingrediente values ('Grana', 1.5, 45)
insert into Ingrediente values ('Verdure di stagione', 1.5, 60)
insert into Ingrediente values ('Patate', 1, 70) --15
insert into Ingrediente values ('Salsiccia', 2, 50)
insert into Ingrediente values ('Ricotta', 1.5, 30)
insert into Ingrediente values ('Provola', 1.5, 40) --18
insert into Ingrediente values ('Gorgonzola', 1.5, 40)
insert into Ingrediente values ('Pomodoro fresco', 1.5, 30)
insert into Ingrediente values ('Basilico', 0.5, 50) --21
insert into Ingrediente values ('Bresaola', 2, 40)
insert into Ingrediente values ('Pomodorini', 1.5, 40)


--CodPizza, CodIngrediente
insert into Menu values (1,1)
insert into Menu values (1,2)

insert into Menu values (2,1)
insert into Menu values (2,3)

insert into Menu values (3,1)
insert into Menu values (3,2)
insert into Menu values (3,4)

insert into Menu values (4,1)
insert into Menu values (4,2)
insert into Menu values (4,5)
insert into Menu values (4,6)
insert into Menu values (4,7)
insert into Menu values (4,8)

insert into Menu values (5,1)
insert into Menu values (5,2)
insert into Menu values (5,9)

insert into Menu values (6,1)
insert into Menu values (6,2)
insert into Menu values (6,10)
insert into Menu values (6,11)
insert into Menu values (6,12)
insert into Menu values (6,13)

insert into Menu values (7,1)
insert into Menu values (7,2)
insert into Menu values (7,14)

insert into Menu values (8,2)
insert into Menu values (8,15)
insert into Menu values (8,16)

insert into Menu values (9,2)
insert into Menu values (9,23)
insert into Menu values (9,17)

insert into Menu values (10,2)
insert into Menu values (10,18)
insert into Menu values (10,19)
insert into Menu values (10,13)

insert into Menu values (11,2)
insert into Menu values (11,20)
insert into Menu values (11,21)

insert into Menu values (12,2)
insert into Menu values (12,22)
insert into Menu values (12,12)

-- ////QUERIES////


select * From Pizza
select * from Menu
select * from Ingrediente
--1. Estrarre tutte le pizze con prezzo superiore a 6 euro.
select Nome, Prezzo
from Pizza 
where Prezzo > 6

--2. Estrarre la pizza/le pizze più costosa/e.
select Nome as [Pizze più care] , Prezzo
from Pizza
where Prezzo in (select  max(Prezzo) as Prezzo
					 from Pizza)

--3. Estrarre le pizze «bianche»
select distinct p.Nome as [Pizze bianche]
from Pizza p 
where p.Nome not in (select p.Nome
					from Pizza p join Menu m on p.CodicePizza = m.CodPizza
								join Ingrediente i on m.CodIngrediente = i.CodiceIngrediente
								where i.Nome = 'Pomodoro')


--4. Estrarre le pizze che contengono funghi (di qualsiasi tipo)
select p.Nome as [Pizze con funghi]
from Pizza p join Menu m on p.CodicePizza = m.CodPizza
			join Ingrediente i on m.CodIngrediente = i.CodiceIngrediente
where i.Nome like '%Funghi%'


--QUERY DI TUTTI I DATI 
SELECT dbo.Pizza.*, dbo.Menu.*, dbo.Ingrediente.*
FROM   dbo.Ingrediente INNER JOIN
             dbo.Menu ON dbo.Ingrediente.CodiceIngrediente = dbo.Menu.CodIngrediente INNER JOIN
             dbo.Pizza ON dbo.Menu.CodPizza = dbo.Pizza.CodicePizza

-- PROCEDURE
--1. Inserimento di una nuova pizza (parametri: nome, prezzo)
create procedure AggiungiPizza
@Nome varchar(50),
@Prezzo decimal(3,2)
as 
insert into Pizza values (@Nome, @Prezzo)
go 
execute AggiungiPizza 'Canadese', 6.50

select * from Pizza


--2. Assegnazione di un ingrediente a una pizza (parametri: nome pizza, nome
--ingrediente)

create procedure AggiungiIngredienteAPizza
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
go

execute AggiungiIngredienteAPizza 'Canadese', 'Mozzarella'

--3. Aggiornamento del prezzo di una pizza (parametri: nome pizza e nuovo prezzo)
create procedure AggiornaPrezzoPizza
@NomePizza varchar(50),
@NuovoPrezzo decimal (3,2)
as 
update Pizza set Prezzo = @NuovoPrezzo where Nome = @NomePizza
go

execute AggiornaPrezzoPizza 'Canadese', 7
--4. Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome
--ingrediente)
create procedure TogliIngredienteDaPizza
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
go

execute TogliIngredienteDaPizza 'Canadese', 'Mozzarella'
select * from Menu


--5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente
--(parametro: nome ingrediente)
create procedure IncrementoPrezzoPizza
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
go

execute IncrementoPrezzoPizza 'Mozzarella di bufala'


--1. Tabella listino pizze (nome, prezzo) (parametri: nessuno)
create function ListinoPizze ()
returns table 
as 
return
select Nome, Prezzo
from Pizza 

select * from dbo.ListinoPizze()


--2. Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome
--ingrediente)
create function ListinoPizzeConIngrediente (@NomeIngrediente varchar(50))
returns table 
as 
return
select p.Nome, p.Prezzo
from Pizza p join Menu m on p.CodicePizza = m.CodPizza
			join Ingrediente i on m.CodIngrediente = i.CodiceIngrediente
where i.Nome = @NomeIngrediente

select * from ListinoPizzeConIngrediente('Funghi')
--3. Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente
--(parametri: nome ingrediente)
create function ListinoPizzeSenzaIngrediente (@NomeIngrediente varchar(50))
returns table 
as 
return


select distinct p.Nome, p.Prezzo
from Pizza p 
where p.Nome not in (select p.Nome
					from Pizza p join Menu m on p.CodicePizza = m.CodPizza
								join Ingrediente i on m.CodIngrediente = i.CodiceIngrediente
					where i.Nome = @NomeIngrediente)

select * from ListinoPizzeSenzaIngrediente('Pomodoro')

--4. Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)
create function NumeroPizzeConIngrediente (@NomeIngrediente varchar(50))
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
--group by p.Nome

select dbo.NumeroPizzeConIngrediente('Funghi')
--5. Calcolo numero pizze che non contengono un ingrediente (parametri: codice
--ingrediente)
create function NumeroPizzeSenzaIngrediente (@CodiceIngrediente int)
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

select  dbo.NumeroPizzeSenzaIngrediente(21) as [Numero pizze senza ingrediente]-- basilico( solo nella caprese)

--6. Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)
create function NumeroIngredientiNellaPizza (@NomePizza varchar(50))
returns int 
as 
BEGIN
declare @IdPizza int
select @IdPizza = p.CodicePizza from Pizza p where p.Nome = @NomePizza

declare @NumIngredienti int	

select @NumIngredienti = count(m.CodPizza)
from Pizza p join Menu m on p.CodicePizza = m.CodPizza
where m.CodPizza = @IdPizza

return @NumIngredienti

END

select dbo.NumeroIngredientiNellaPizza('Margherita') as [Numero Ingredienti]



--VIEW--

--Realizzare una view che rappresenta il menù con tutte le pizze.
--Opzionale: la vista deve restituire una tabella con prima colonna
--contenente il nome della pizza, seconda colonna il prezzo e terza
--colonna la lista unica di tutti gli ingredienti separati da virgola
--(vedi esempio in tabella)
--Pizza			Prezzo	Ingredienti
--Margherita	5.00	Pomodoro, Mozzarella
--Diavola		7.00	Pomodoro, Mozzarella, Spianata Piccante

CREATE VIEW [Menu Pizze]
AS
select Nome, Prezzo
from Pizza

select * from [Menu Pizze]

create view [Menu completo]
as
select p.Nome, p.Prezzo 
from Pizza p 