-- 1) Relação do nome do paciente, nome do médico e o ID da consulta. Em ordem alfabetica do nome do paciente.
SELECT P.Nome, F.Nome, C.IdConsulta
FROM Paciente P, Funcionario F, Consulta C
WHERE C.fk_Paciente_CPF=P.CPF AND C.fk_Medico_fk_Funcionario_Id_func=F.Id_func
ORDER BY 1;

-- 2) Relação do nome do paciente, nome do médico e data da consulta. Em ordem de data e paciente que nasceram depois de 1990.
SELECT P.Nome, F.Nome, C.DataConsulta
FROM Paciente P, Funcionario F, Consulta C
WHERE C.fk_Paciente_CPF=P.CPF AND C.fk_Medico_fk_Funcionario_Id_func=F.Id_func AND P.DataNasc > '1990-01-01'
ORDER BY 3;

-- 3) Relação do nome da clinica, nome do funcionário que tenham realizado cirurgia entre fev/20 e out/22 e que o nome começe com Gustavo.
SELECT RazaoSocial, Nome
FROM Clinica R, Funcionario F, Cirurgia C, EquipeCirurgia_Realiza E
WHERE F.fk_Clinica_CNPJ=R.CNPJ AND F.fk_Clinica_CNPJ=C.Clinica_CNPJ AND E.fk_Funcionario_Id_func=F.Id_func AND C.DataCirurgia BETWEEN'2020-02-01' AND '2022-10-31' AND F.Nome LIKE('Marta%');

-- 4) Relação do nome do paciente, nome do médico e data da consulta, onde o medico seja Ortopedista ou Dermatologista e o paciente não possua plano de saúde
SELECT P.Nome, F.Nome, C.DataConsulta
FROM Paciente P, Consulta C,
     Funcionario F JOIN Medico M ON F.Id_func = M.Funcionario_Id_func
WHERE C.fk_Paciente_CPF=P.CPF AND C.fk_Medico_fk_Funcionario_Id_func=F.Id_func AND
    Especialidade IN ('Ortopedista', 'Dermatologista') AND PlanoSaude_IdPlano IS NULL;

-- 5) Relação do nome do funcionário com o número de cirurgias realizadas, em ordem alfabetica do nome do médico.
SELECT Nome, COUNT(ECR.fk_Cirurgia_Id_Cirurgia) AS NumeroCirurgias
FROM Funcionario F,
Cirurgia C JOIN EquipeCirurgia_Realiza ECR ON C.Id_Cirurgia = ECR.fk_Cirurgia_Id_Cirurgia
WHERE F.Id_func=ECR.fk_Funcionario_Id_func
GROUP BY Nome
ORDER BY Nome;

-- 6) Relação do nome do funcionário que seja médico com o número de cirurgias realizadas.
SELECT Nome, COUNT(Id_Cirurgia) AS NumeroCirurgias
FROM Funcionario F JOIN Medico M ON F.Id_func = M.Funcionario_Id_func,
    Cirurgia C JOIN EquipeCirurgia_Realiza ECR on C.Id_Cirurgia = ECR.fk_Cirurgia_Id_Cirurgia
WHERE ECR.fk_Funcionario_Id_func=M.Funcionario_Id_func
GROUP BY Nome;

-- 7) Selecione o codigo da cirurgia com maior numero de equipamentos
SELECT fk_Cirurgia_Id_Cirurgia, COUNT(*) as QtdeEquipa
FROM CirurgiaEquipamento_Utiliza
GROUP BY fk_Cirurgia_Id_Cirurgia
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM CirurgiaEquipamento_Utiliza GROUP BY fk_Cirurgia_Id_Cirurgia);

-- 9) Selecione os funcionários que realizaram cirurgia de ortopedia mas não realizaram cirurgia de cardiologia
SELECT F.Nome from Funcionario F, EquipeCirurgia_Realiza E
where E.fk_Funcionario_Id_func = F.Id_func AND E.fk_Cirurgia_Id_Cirurgia = 12345
AND NOT EXISTS(SELECT F.Nome from Funcionario F, EquipeCirurgia_Realiza E where E.fk_Funcionario_Id_func = F.Id_func AND E.fk_Cirurgia_Id_Cirurgia = 14795);

-- 10) Selecione a clinica que tem o maior numero de funcionários cadastrados
SELECT RazaoSocial, COUNT(*) AS qtde
FROM Clinica C INNER JOIN Funcionario F
ON F.fk_Clinica_CNPJ = C.CNPJ
GROUP BY Nome
HAVING qtde >= ALL(SELECT COUNT(*) FROM Clinica C INNER JOIN Funcionario F ON F.fk_Clinica_CNPJ = C.CNPJ GROUP BY Nome);
