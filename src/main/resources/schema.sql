--Criando usuario
CREATE USER cassiano IDENTIFIED BY root;

GRANT CONNECT,RESOURCE,DBA,UNLIMITED TABLESPACE TO cassiano;

SET SERVEROUTPUT ON;
--Criando tabelas

create table endereco(
cod_endereco number(38) primary key,
rua varchar(255) not null,
numero number(38),
complemento varchar(255),
bairro varchar(255),
cidade varchar(255),
UF varchar(2),
CEP number(8)
);

create table pessoa(
cod_pessoa number(38) primary key,
nome varchar(255) not null,
cpf_cnpj number(14) not null unique,
cod_endereco number(38),
telefone number(12),
data_cadastro DATE,
CONSTRAINT FK_endereco FOREIGN KEY (cod_endereco) REFERENCES endereco (cod_endereco)
);

create table status_conta(
cod_status char(1) not null primary key,
descricao varchar(255)not null
);

INSERT INTO STATUS_CONTA(COD_STATUS,DESCRICAO) VALUES ('A','ATIVO');

create table conta(
cod_conta number(38) not null,
cod_pessoa number(38) not null,
status char(1) not null,
saldo number(38) not null,
CONSTRAINT FK_PESSOA FOREIGN KEY (cod_pessoa) REFERENCES PESSOA (cod_pessoa),
CONSTRAINT PK_COD_CONTA primary key(cod_conta),
CONSTRAINT FK_STATUS_CONTA FOREIGN KEY (status) REFERENCES status_conta (cod_status)
);

create table historico_movimento(cod_movimentacao number(38)primary key,
                                 data_movimentacao timestamp not null,
                                 cod_conta number(38) not null,
                                 cod_pessoa number(38) not null,
                                 valor number(38) not null,
                                 CONSTRAINT FK_historico_movimento_CONTA FOREIGN KEY (cod_conta) REFERENCES conta(cod_conta),
                                 CONSTRAINT FK_historico_movimento_PESSOA FOREIGN KEY (cod_pessoa) REFERENCES pessoa(cod_pessoa));

--Criando sequences
                                 
create sequence seq_pessoa
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
nocache
cycle;

create sequence seq_ENDERECO
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
nocache
cycle;

create sequence seq_conta
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
nocache
cycle;

create sequence seq_historico_movimentacao
minvalue 1
maxvalue 9999999999
start with 1
increment by 1
nocache
cycle;

--Criando packages, procedures e function

create or replace PACKAGE PKG_PESSOA AS    

PROCEDURE proc_cadastrar_pessoa(pNome in pessoa.nome%TYPE,                              
                                pCpf_cnpj in pessoa.cpf_cnpj%type,                              
                                pTelefone in pessoa.telefone%type,                              
                                pRua in endereco.rua%type,                              
                                pNumero in endereco.numero%type,                              
                                pComplemento in endereco.complemento%type,                              
                                pBairro in endereco.bairro%type,                              
                                pCidade in endereco.cidade%type,                              
                                pUF in endereco.uf%type,                              
                                pCEP in endereco.CEP%type,                              
                                mensagem out varchar,                              
                                cod_erro out varchar);   

FUNCTION func_remover_pessoa(pCod_pessoa in pessoa.cod_pessoa%type) RETURN NUMBER ;    

PROCEDURE proc_alterar_pessoa(pCod_pessoa in pessoa.cod_pessoa%type,                            
                              pNome in pessoa.nome%TYPE,                            
                              pTelefone in pessoa.telefone%type,                            
                              pCod_endereco in pessoa.cod_endereco%type,                            
                              pRua in endereco.rua%type,                            
                              pNumero in endereco.numero%type,                                                        
                              pComplemento in endereco.complemento%type,                            
                              pBairro in endereco.bairro%type,                            
                              pCidade in endereco.cidade%type,                            
                              pUF in endereco.UF%type,                            
                              pCep in endereco.CEP%type,                            
                              mensagem out varchar,                            
                              cod_erro out varchar);   

PROCEDURE proc_consultar_pessoa(pCod_pessoa in pessoa.cod_pessoa%type,                            
                                pessoa_out out pessoa%rowtype,                            
                                endereco_out out endereco%rowtype,                            
                                mensagem out varchar,                            
                                cod_erro out varchar);

END PKG_PESSOA;

create or replace PACKAGE BODY PKG_PESSOA 
AS PROCEDURE proc_cadastrar_pessoa(pNome in pessoa.nome%TYPE,                             
								   pCpf_cnpj in pessoa.cpf_cnpj%type,                              
								   pTelefone in pessoa.telefone%type,                              
								   pRua in endereco.rua%type,                              
								   pNumero in endereco.numero%type,                              
								   pComplemento in endereco.complemento%type,                              
								   pBairro in endereco.bairro%type,                              
								   pCidade in endereco.cidade%type,                              
								   pUF in endereco.uf%type,                              
								   pCEP in endereco.CEP%type,                              
								   mensagem out varchar,                              
								   cod_erro out varchar)
IS 
vCpf_cnpj pessoa.cpf_cnpj%TYPE;
vCod_endereco pessoa.cod_endereco%type;
ex_cpf_ou_cnpj_já_existe EXCEPTION;

BEGIN    

vCod_endereco:= seq_pessoa.Nextval;        

INSERT INTO ENDERECO(COD_ENDERECO,RUA,NUMERO,complemento,BAIRRO,CIDADE,UF,CEP)    
VALUES(vCod_endereco,pRua,pNumero,pComplemento,pBairro,pCidade,pUF,pCEP);            

BEGIN            

SELECT CPF_CNPJ INTO vCpf_cnpj from pessoa where cpf_cnpj = pCpf_cnpj;        

EXCEPTION            
WHEN OTHERS THEN            
vCpf_cnpj:='';        
END;        

if(vCpf_cnpj=pCpf_cnpj) THEN   
     RAISE ex_cpf_ou_cnpj_já_existe;    
end if;        

INSERT INTO PESSOA(COD_PESSOA,NOME, CPF_CNPJ, TELEFONE,data_cadastro,cod_endereco)    
VALUES(seq_pessoa.Nextval,pNome, pCpf_cnpj, pTelefone,sysdate ,vCod_endereco);        
mensagem:= 'usuario cadasdtrado com sucesso';    

COMMIT;
EXCEPTION      
	WHEN ex_cpf_ou_cnpj_já_existe THEN
		mensagem:= 'O cpf ou cnpj: '|| pCpf_cnpj || 'já está cadastrado!';        
		ROLLBACK;       
	
	WHEN OTHERS THEN        
		cod_erro:=SQLCODE;        
	mensagem:=SQLERRM;        
	ROLLBACK;
END;

FUNCTION func_remover_pessoa(pCod_pessoa in pessoa.cod_pessoa%type) 
RETURN NUMBER AS cod_erro NUMBER;
vCod_endereco pessoa.cod_endereco%type;

BEGIN
     select cod_endereco into vCod_endereco from pessoa where cod_pessoa = pCod_pessoa;     
	 delete from pessoa where cod_pessoa = pCod_pessoa;     
	 delete from endereco where cod_endereco = vCod_endereco;
	 COMMIT;
	 RETURN cod_erro;
	 
	 EXCEPTION    
	 WHEN OTHERS THEN    
		cod_erro:=SQLCODE;    
		RETURN cod_erro;    
		ROLLBACK;
END;

PROCEDURE proc_alterar_pessoa(pCod_pessoa in pessoa.cod_pessoa%type,                            
							  pNome in pessoa.nome%TYPE,                            
							  pTelefone in pessoa.telefone%type,                            
							  pCod_endereco in pessoa.cod_endereco%type,                            
							  pRua in endereco.rua%type,                            
							  pNumero in endereco.numero%type,                            
							  pComplemento in endereco.complemento%type,                            
							  pBairro in endereco.bairro%type,                            
							  pCidade in endereco.cidade%type,                            
							  pUF in endereco.UF%type,                            
							  pCep in endereco.CEP%type,                            
							  mensagem out varchar,                            
							  cod_erro out varchar)
							  is 
BEGIN    

	UPDATE PESSOA    
	SET NOME = NVL(pNome,NOME),        
	telefone = NVL(pTelefone,telefone)    
	where cod_pessoa = pCod_pessoa;        
	
	UPDATE ENDERECO    
	SET RUA = NVL(pRua,rua),        
	numero = NVL(pNumero,numero),        
	complemento = NVL(pComplemento,complemento),        
	bairro = NVL(pBairro,bairro),        
	cidade = NVL(pCidade,cidade),        
	UF = NVL(pUF,UF),        
	CEP = NVL(pCep,CEP)    
	WHERE Cod_endereco = pCod_Endereco;    
	
	COMMIT;
	
	
	EXCEPTION    
	
		WHEN OTHERS THEN    
			cod_erro:=SQLCODE;    
			mensagem:=SQLERRM;    
			ROLLBACK;
END;

PROCEDURE proc_consultar_pessoa(pCod_pessoa in pessoa.cod_pessoa%type,                            
							    pessoa_out out pessoa%rowtype,                            
								endereco_out out endereco%rowtype,                            
								mensagem out varchar,                            
								cod_erro out varchar)IS                         
BEGIN    

SELECT COD_PESSOA,NOME,CPF_CNPJ,COD_ENDERECO,TELEFONE,TO_DATE(DATA_CADASTRO,'DD/MM/YYYY')      

INTO pessoa_out     
FROM PESSOA     
WHERE cod_pessoa = pCod_pessoa;        

SELECT COD_ENDERECO,RUA,NUMERO,COMPLEMENTO,BAIRRO,CIDADE,UF,CEP     
INTO endereco_out     
FROM endereco     
WHERE cod_endereco = pessoa_out.cod_endereco;    

EXCEPTION    
	WHEN OTHERS THEN    
	cod_erro:=SQLCODE;    
	mensagem:=SQLERRM;

END;

END PKG_PESSOA;

create or replace PACKAGE PKG_CONTA AS 

PROCEDURE proc_cadastrar_conta(pCod_pessoa in conta.cod_pessoa%type,
                               pStatus in conta.status%type,
                               pSaldo in conta.saldo%type,
                               mensagem out varchar,
                               cod_erro out varchar); 
								
PROCEDURE proc_alterar_conta(pCod_conta in conta.cod_conta%type,
							 pCod_pessoa in conta.cod_pessoa%type,
							 pStatus in conta.status%type,
							 pSaldo in conta.saldo%type,
							 mensagem out varchar,
							 cod_erro out varchar); 
								
FUNCTION func_remover_conta(pCod_conta in conta.cod_conta%type,
                            pCod_pessoa in conta.cod_pessoa%type)RETURN NUMBER; 
							 
PROCEDURE proc_consultar_conta_por_id(pCod_conta in conta.cod_conta%type,
                                  	  pCod_pessoa in conta.cod_pessoa%type,
                                  	  mensagem out varchar,
                                  	  cod_erro out varchar,
									  conta_out out conta%rowtype);

END PKG_CONTA;

create or replace PACKAGE BODY PKG_CONTA AS     

PROCEDURE proc_cadastrar_conta(pCod_pessoa in conta.cod_pessoa%type,
                                pStatus in conta.status%type,
                                pSaldo in conta.saldo%type,
                                mensagem out varchar,
                                cod_erro out varchar)                                 
								as    
BEGIN        

	INSERT INTO CONTA (COD_CONTA,COD_PESSOA,STATUS,SALDO)        
	VALUES(SEQ_CONTA.Nextval,pCod_pessoa,pStatus,pSaldo);

    COMMIT;
    EXCEPTION        WHEN OTHERS THEN        cod_erro:=SQLCODE;
        mensagem:=SQLERRM;
        ROLLBACK;
    END;
	
PROCEDURE proc_alterar_conta(pCod_conta in conta.cod_conta%type,
                                pCod_pessoa in conta.cod_pessoa%type,
                                pStatus in conta.status%type,
                                pSaldo in conta.saldo%type,
                                mensagem out varchar,
                                cod_erro out varchar) 
								is    
BEGIN         

UPDATE CONTA          
SET    STATUS = NVL(pStatus,STATUS),
       SALDO = NVL(pSaldo,SALDO)         
WHERE             
	   COD_CONTA = pCod_conta AND
	   COD_PESSOA = pCod_pessoa;
	   
    COMMIT;
	
    EXCEPTION        
		WHEN OTHERS THEN        
			cod_erro:=SQLCODE;
			mensagem:=SQLERRM;
			ROLLBACK;
end;

FUNCTION func_remover_conta(pCod_conta in conta.cod_conta%type,
                            pCod_pessoa in conta.cod_pessoa%type)
							return number AS    
cod_erro NUMBER;

BEGIN      
	
	DELETE FROM CONTA       
	WHERE  
		COD_CONTA = pCod_conta AND
		COD_PESSOA = pCod_pessoa;
    COMMIT;
	
    return cod_erro;
	
    EXCEPTION        
		WHEN OTHERS THEN        
			cod_erro:=SQLCODE;
			return cod_erro;
			ROLLBACK;
    end;
	
   PROCEDURE proc_consultar_conta_por_id(pCod_conta in conta.cod_conta%type,
                                  pCod_pessoa in conta.cod_pessoa%type,
                                  mensagem out varchar,
                                  cod_erro out varchar,
                                  conta_out out conta%rowtype) 
								  is   
	BEGIN        
	
	SELECT COD_CONTA,COD_PESSOA,STATUS,SALDO        
	INTO conta_out        
	FROM CONTA        
	WHERE COD_CONTA = pCod_conta and
	COD_PESSOA = pCod_pessoa;
	
   COMMIT;
   EXCEPTION        
		WHEN OTHERS THEN        
			cod_erro:=SQLCODE;
			mensagem:=SQLERRM;
			ROLLBACK;
   end;
   
END PKG_CONTA;



--Criando trigger

CREATE OR REPLACE  TRIGGER movimentacao_conta
    AFTER INSERT OR UPDATE OF saldo
  ON conta
  FOR EACH ROW
  WHEN (NEW.SALDO <> OLD.SALDO)  
  BEGIN
    INSERT INTO historico_movimento(COD_MOVIMENTACAO,DATA_MOVIMENTACAO,COD_CONTA,COD_PESSOA,VALOR)
    VALUES (SEQ_HISTORICO_MOVIMENTACAO.NEXTVAL,SYSDATE,:OLD.COD_CONTA,:OLD.COD_PESSOA,:NEW.SALDO-:OLD.SALDO);  
  END;


