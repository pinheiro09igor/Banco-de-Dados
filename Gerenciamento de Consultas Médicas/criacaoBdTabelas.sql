CREATE DATABASE IF NOT EXISTS trabBD;
USE trabDB;

CREATE TABLE IF NOT EXISTS Clinica (
                         CNPJ CHAR(20) primary key,
                         RazaoSocial CHAR(30),
                         cidade char(30) NOT NULL,
                         estado char(2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Funcionario (
                             Id_func int primary key,
                             Nome CHAR(100) NOT NULL,
                             Profissao CHAR(30) NOT NULL,
                             Data_nasc DATE,
                             Sexo CHAR(2),
                             fk_Clinica_CNPJ CHAR(20) NOT NULL,

                             foreign key(fk_Clinica_CNPJ) references Clinica(CNPJ) on delete restrict
);

CREATE TABLE IF NOT EXISTS PlanoSaude (
                            IdPlano INT primary key,
                            Nome CHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS Paciente (
                          CPF CHAR(15) primary key,
                          Nome CHAR(100) NOT NULL,
                          DataNasc DATE NOT NULL, /* AAAA-MM-DD */
                          Sexo CHAR(1) NOT NULL,
                          Clinica_CNPJ CHAR(20) NOT NULL,
                          PlanoSaude_IdPlano INT,

                          foreign key(Clinica_CNPJ) references Clinica(CNPJ) on delete restrict,
                          foreign key(PlanoSaude_IdPlano) references PlanoSaude(IdPlano) on delete restrict
);

CREATE TABLE IF NOT EXISTS Sala (
                      Id_sala INT primary key,
                      Numero INT NOT NULL,
                      TipoSala CHAR(9) NOT NULL,
                      Clinica_CNPJ CHAR(20) NOT NULL,

                      foreign key(Clinica_CNPJ) references Clinica(CNPJ) on delete restrict
);

CREATE TABLE IF NOT EXISTS Cirurgia (
                          Id_Cirurgia INT primary key,
                          TipoCirurgia CHAR(50) NOT NULL,
                          Horario TIME(0) NOT NULL, /* HH:MM:SS */
                          DataCirurgia DATE NOT NULL, /* AAAA-MM-DD */
    /* DataCirurgia DATETIME(0), AAAA-MM-DD HH:MM:SS */
                          Clinica_CNPJ CHAR(20),
                          Sala_Id_sala INT,
                          Paciente_CPF CHAR(15),

                          foreign key(Clinica_CNPJ) references Clinica(CNPJ) on delete restrict,
                          foreign key(Sala_Id_sala) references Sala(Id_sala) on delete restrict,
                          foreign key(Paciente_CPF) references Paciente(CPF) on delete restrict
);

CREATE TABLE IF NOT EXISTS Medico (
                        CRM CHAR(15),
                        Especialidade CHAR(50),
                        Funcionario_Id_func INT,

                        foreign key(Funcionario_Id_func) references Funcionario(Id_func) on delete restrict
);

CREATE TABLE IF NOT EXISTS Enfermeiro (
                            COREN CHAR(20),
                            Funcionario_Id_func INT,

                            foreign key(Funcionario_Id_func) references Funcionario(Id_func) on delete restrict
);

CREATE TABLE IF NOT EXISTS Equipamento (
                             Id_Equipamento INT primary key,
                             Descricao CHAR(50),
                             Clinica_CNPJ CHAR(20),

                             foreign key(Clinica_CNPJ) references Clinica(CNPJ) on delete restrict
);

CREATE TABLE IF NOT EXISTS Consulta (
                          IdConsulta INT primary key,
                          Horario TIME,
                          DataConsulta DATE,
                          fk_Clinica_CNPJ CHAR(20),
                          fk_Medico_fk_Funcionario_Id_func INT,
                          fk_Paciente_CPF CHAR(15),
                          fk_Sala_Id_sala INT,

                          foreign key(fk_Clinica_CNPJ) references Clinica(CNPJ) on delete restrict,
                          foreign key (fk_Medico_fk_Funcionario_Id_func) references Medico(Funcionario_Id_func) on delete restrict,
                          foreign key(fk_Paciente_CPF) references Paciente(CPF) on delete restrict,
                          foreign key(fk_Sala_Id_sala) references Sala(Id_sala) on delete restrict
);

CREATE TABLE IF NOT EXISTS EquipeCirurgia_Realiza (
                                        fk_Funcionario_Id_func INTEGER,
                                        fk_Cirurgia_Id_Cirurgia INTEGER,

                                        foreign key(fk_Funcionario_Id_func) references Funcionario(Id_func) on delete restrict,
                                        foreign key(fk_Cirurgia_Id_Cirurgia) references Cirurgia(Id_Cirurgia) on delete restrict
);

CREATE TABLE IF NOT EXISTS CirurgiaEquipamento_Utiliza (
                                             fk_Equipamento_Id_Equipamento INT,
                                             fk_Cirurgia_Id_Cirurgia INT,

                                             foreign key(fk_Equipamento_Id_Equipamento) references Equipamento(Id_Equipamento) on delete restrict,
                                             foreign key(fk_Cirurgia_Id_Cirurgia) references Cirurgia(Id_Cirurgia) on delete restrict
);
