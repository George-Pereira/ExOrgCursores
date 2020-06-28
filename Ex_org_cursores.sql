CREATE DATABASE ex10a
GO
USE ex10a

create table envio (
CPF varchar(20),
NR_LINHA_ARQUIV	int,
CD_FILIAL int,
DT_ENVIO datetime,
NR_DDD int,
NR_TELEFONE	varchar(10),
NR_RAMAL varchar(10),
DT_PROCESSAMENT	datetime,
NM_ENDERECO varchar(200),
NR_ENDERECO int,
NM_COMPLEMENTO	varchar(50),
NM_BAIRRO varchar(100),
NR_CEP varchar(10),
NM_CIDADE varchar(100),
NM_UF varchar(2),
)

create table endereço(
CPF varchar(20),
CEP	varchar(10),
PORTA	int,
ENDEREÇO	varchar(200),
COMPLEMENTO	varchar(100),
BAIRRO	varchar(100),
CIDADE	varchar(100),
UF Varchar(2))

create procedure sp_insereenvio
as
declare @cpf as int
declare @cont1 as int
declare @cont2 as int
declare @conttotal as int
set @cpf = 11111
set @cont1 = 1
set @cont2 = 1
set @conttotal = 1
	while @cont1 <= @cont2 and @cont2 < = 100
			begin
				insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
				values (cast(@cpf as varchar(20)), @cont1,GETDATE())
				insert into endereço (CPF,PORTA,ENDEREÇO)
				values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
				set @cont1 = @cont1 + 1
				set @conttotal = @conttotal + 1
				if @cont1 > = @cont2
					begin
						set @cont1 = 1
						set @cont2 = @cont2 + 1
						set @cpf = @cpf + 1
					end
	end
exec sp_insereenvio

select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereço order by CPF asc

CREATE PROCEDURE sp_EnderecoparaEnvio
AS
BEGIN
	DECLARE @n_linha INT
	DECLARE cur_End CURSOR FOR
	SELECT DISTINCT NR_LINHA_ARQUIV FROM envio
	OPEN cur_End
	FETCH NEXT FROM cur_End INTO @n_linha
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE envio SET NM_ENDERECO = endDados.ENDEREÇO, NR_CEP = endDados.COMPLEMENTO, NM_BAIRRO = endDados.BAIRRO, NM_UF = endDados.UF, NR_ENDERECO = endDados.PORTA FROM (SELECT ENDEREÇO, PORTA, COMPLEMENTO, CIDADE, UF, BAIRRO FROM (SELECT ROW_NUMBER() OVER (ORDER BY cpf ASC) AS numero_linha, ENDEREÇO, PORTA, COMPLEMENTO, CIDADE, UF, BAIRRO FROM endereço)AS endPorta WHERE numero_linha = @n_linha ) as endDados WHERE NR_LINHA_ARQUIV = @n_linha
		FETCH NEXT FROM cur_End INTO @n_linha
	END
	CLOSE cur_End
	DEALLOCATE cur_End
END
exec sp_EnderecoparaEnvio
