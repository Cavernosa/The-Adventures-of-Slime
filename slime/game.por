programa
{
	inclua biblioteca Calendario --> c
	inclua biblioteca Graficos --> g
	inclua biblioteca Arquivos --> a
	inclua biblioteca Objetos --> o
	inclua biblioteca Teclado --> t
	inclua biblioteca Texto --> tx
	inclua biblioteca Tipos --> tp
	inclua biblioteca Mouse --> m
	inclua biblioteca Sons --> s
	inclua biblioteca Util --> u

	// Configurações de jogo
	cadeia configuracoes_lingua = "Português (BR)"
	
	logico configuracoes_musica = verdadeiro,
	configuracoes_efeitos_sonoros = verdadeiro
	
	inteiro taxa_fps_maxima = 0
	
	// Configurações
	inteiro janela[] = {800, 600},
	lar = janela[0],
	alt = janela[1],
	janela_cor_fundo = 0x202030,
	janela_cor_fundo_interface = 0xB0C4DE,
	janela_cor_conteudo_interface = janela_cor_fundo,
	MENU = 0, CONFIGURACOES = 1, CUSTOMIZACAO_DE_PERSONAGEM = 2, JOGO = 3,
	tela_atual = MENU,
	fase_atual = 1,
	pontuacao = 0,
	contador_tempo_inicio = 0,
	contador_tempo_minutos = 0,
	fps_tempo_inicio = 0,
	fps_taxa = 0,
	fps_atual = 0

	
	cadeia nome_personagem[3] = {
		"Slimey",
		"Goop",
		"Slurry"
	},
	pasta_sprites = "/sprites",
	pasta_fonts = "/fonts",
	pasta_menus = "/menus",
	pasta_config = "/config",
	pasta_lang = "/lang",
	pasta_sons ="/sons",
	pasta_fases = "/fases",
	pasta_customizacao = "/customizacao"
	
	logico contador_tempo_obter_tempo = verdadeiro,
	fps_obter_tempo = verdadeiro,
	exibir_tutorial = falso,
	executando = verdadeiro,
	erro_carregamento_arquivos = falso
	
	// Arquivos
	inteiro arquivo_configuracoes = 0,
	obj_pontuacao = 0,
	pt_br = 0,
	en_us = 0
	
	inteiro lang_pt_br = 0,
	lang_en_us = 0

	// Imagens
	inteiro menu_play_button = 0,
	menu_config_button = 0,
	menu_quit_button = 0,
	sprite_fantasma_cinza = 0,
	customizacao_slime_vermelho = 0,
	customizacao_slime_laranja = 0,
	customizacao_slime_amarelo = 0,
	customizacao_slime_verde = 0,
	customizacao_slime_azul = 0,
	customizacao_slime_ciano = 0,
	customizacao_slime_roxo = 0,
	customizacao_slime_rosa = 0,
	sprite_slime_vermelho = 0,
	sprite_slime_laranja = 0,
	sprite_slime_amarelo = 0,
	sprite_slime_verde = 0,
	sprite_slime_azul = 0,
	sprite_slime_ciano = 0,
	sprite_slime_roxo = 0,
	sprite_slime_rosa = 0

	// Sons
	inteiro som_button_click = 0,
	som_point_collected1 = 0,
	som_point_collected2 = 0

	// Jogador
	cadeia jogador_cor = "verde"
	inteiro jogador_cor_numero = 3
	inteiro jogador_velocidade,
	jogador_sprite = g.carregar_imagem(pasta_sprites + "/slime_" + jogador_cor + ".png"),
	jogador_tamanho[2] = {
		g.largura_imagem(jogador_sprite) / 2,
		g.altura_imagem(jogador_sprite)
	},
	jogador_posicao[2] = {
		(lar / 2) - (jogador_tamanho[0] / 2),
		(alt / 2) - (jogador_tamanho[1] / 2)
	}
	logico jogador_virado_para_a_direita = verdadeiro

	// Ponto
	cadeia ponto_cor = "vermelho"
	inteiro maior_pontuacao = 0,
	ponto_sprite = g.carregar_imagem(pasta_sprites + "/ponto_" + ponto_cor + ".png"),
	ponto_tamanho = g.altura_imagem(ponto_sprite),
	ponto_posicao[2]
	logico sortear_nova_posicao_ponto = verdadeiro

	// Funções principais
	funcao finalizar(){
		liberar_imagens()
		liberar_sons()
		g.minimizar_janela()
		u.aguarde(100)
		g.encerrar_modo_grafico()
		executando = falso
	}
	funcao inicio(){
		// Inicia o modo gráfico e define as dimensões da janela
		g.iniciar_modo_grafico(falso)
		g.definir_dimensoes_janela(janela[0], janela[1])
		g.definir_titulo_janela("The Adventures of Slime")

		// Carrega os arquivos
		carregar_todos_os_arquivos()
		
		// Loop responsável por fazer o programa funcionar
		enquanto(executando){
			// Detecta se o jogador apertou SHIFT + ESC, para finalizar o loop
			se(t.tecla_pressionada(t.TECLA_ESC) e t.tecla_pressionada(t.TECLA_SHIFT)){
				finalizar()
				pare
			}

			escolha(jogador_cor_numero){
				caso 0:
					g.definir_icone_janela(customizacao_slime_vermelho)
					pare
					
				caso 1:
					g.definir_icone_janela(customizacao_slime_laranja)
					pare
					
				caso 2:
					g.definir_icone_janela(customizacao_slime_amarelo)
					pare
					
				caso 3:
					g.definir_icone_janela(customizacao_slime_verde)
					pare
					
				caso 4:
					g.definir_icone_janela(customizacao_slime_azul)
					pare
					
				caso 5:
					g.definir_icone_janela(customizacao_slime_ciano)
					pare
					
				caso 6:
					g.definir_icone_janela(customizacao_slime_roxo)
					pare
					
				caso 7:
					g.definir_icone_janela(customizacao_slime_rosa)
					pare
			}
			
			obter_fps()
			
			// Define a cor de fundo da janela
			g.definir_cor(janela_cor_fundo)
			g.limpar()
			
			// Esta é a tela de menu
			se(tela_atual == MENU){
				menu()
			}
			
			// Esta é a tela de configurações
			senao se(tela_atual == CONFIGURACOES){
				configuracoes()
			}
			
			// Esta é a tela de seleção de personagem
			senao se(tela_atual == CUSTOMIZACAO_DE_PERSONAGEM){
				customizacao_de_personagem()
			}
			
			// Esta é a tela de jogo
			senao se(tela_atual == JOGO){
				jogo()
			}

			// Detecta se o jogador apertou uma determinada tecla que tenha uma função específica
			funcoes_teclado()
			
			// Renderiza os desenhos;
			// [!] O "se(executando)" serve para não ocorrer um erro, quando o jogador apertar SHIFT + ESC
			se(executando){
				g.renderizar()
			}
		}
	}

	// Funções referentes aos desenhos
	funcao desenhar_texto_carregamento_de_arquivos(cadeia texto){
		g.definir_cor(janela_cor_fundo_interface)
		centralizar_texto(alt / 2, "CARREGANDO ARQUIVOS")
		centralizar_texto(alt / 2 + (2 * g.altura_texto("A")), "Carregando: " + texto)
		g.renderizar()
	}
	funcao desenhar_interface(){
		// Desenha o retângulo de fundo
		g.definir_cor(janela_cor_fundo_interface)
		g.desenhar_retangulo(0, 0, lar, 25, falso, verdadeiro)

		// Define a cor do conteúdo a ser desenhado na interface
		g.definir_cor(janela_cor_conteudo_interface)

		// Desenhos da interface
		interface_desenhar_pontuacao()
		centralizar_texto(7, contador_tempo_minutos + ":" + interface_obter_tempo())
		interface_desenhar_fps()
	}
	funcao desenhar_jogador(){
		// Desenha o jogador
		se(jogador_virado_para_a_direita){
			g.desenhar_porcao_imagem(jogador_posicao[0], jogador_posicao[1],
			0, 0, jogador_tamanho[0], jogador_tamanho[1], jogador_sprite)
		}
		senao{
			g.desenhar_porcao_imagem(jogador_posicao[0], jogador_posicao[1],
			jogador_tamanho[0], 0, jogador_tamanho[0], jogador_tamanho[1], jogador_sprite)
		}
	}
	funcao desenhar_ponto(){
		// Desenha o ponto
		g.desenhar_imagem(ponto_posicao[0], ponto_posicao[1], ponto_sprite)
	}
	
	// Funções referentes às telas
	funcao customizacao_de_personagem(){
		g.definir_cor(janela_cor_fundo_interface)
		g.definir_tamanho_texto(20.0)
		centralizar_texto((alt / 4) / 4, lang_json("customizacao_de_personagem_customizacao_de_personagem"))
		
		g.definir_tamanho_texto(14.0)
		centralizar_texto((alt / 4) / 2, "- " + lang_json("customizacao_de_personagem_cor_do_slime") + " -")
		
		escolha(jogador_cor_numero){
			caso 0:
				g.desenhar_imagem((lar / 2) - (g.largura_imagem(customizacao_slime_vermelho) / 2) + 10,
					(alt / 2) - (g.altura_imagem(customizacao_slime_vermelho) / 2),
					customizacao_slime_vermelho)
				pare
				
			caso 1:
				g.desenhar_imagem((lar / 2) - (g.largura_imagem(customizacao_slime_laranja) / 2) + 10,
					(alt / 2) - (g.altura_imagem(customizacao_slime_laranja) / 2),
					customizacao_slime_laranja)
				pare
				
			caso 2:
				g.desenhar_imagem((lar / 2) - (g.largura_imagem(customizacao_slime_amarelo) / 2) + 10,
					(alt / 2) - (g.altura_imagem(customizacao_slime_amarelo) / 2),
					customizacao_slime_amarelo)
				pare
				
			caso 3:
				g.desenhar_imagem((lar / 2) - (g.largura_imagem(customizacao_slime_verde) / 2) + 10,
					(alt / 2) - (g.altura_imagem(customizacao_slime_verde) / 2),
					customizacao_slime_verde)
				pare
				
			caso 4:
				g.desenhar_imagem((lar / 2) - (g.largura_imagem(customizacao_slime_azul) / 2) + 10,
					(alt / 2) - (g.altura_imagem(customizacao_slime_azul) / 2),
					customizacao_slime_azul)
				pare
				
			caso 5:
				g.desenhar_imagem((lar / 2) - (g.largura_imagem(customizacao_slime_ciano) / 2) + 10,
					(alt / 2) - (g.altura_imagem(customizacao_slime_ciano) / 2),
					customizacao_slime_ciano)
				pare
				
			caso 6:
				g.desenhar_imagem((lar / 2) - (g.largura_imagem(customizacao_slime_roxo) / 2) + 10,
					(alt / 2) - (g.altura_imagem(customizacao_slime_roxo) / 2),
					customizacao_slime_roxo)
				pare
				
			caso 7:
				g.desenhar_imagem((lar / 2) - (g.largura_imagem(customizacao_slime_rosa) / 2) + 10,
					(alt / 2) - (g.altura_imagem(customizacao_slime_rosa) / 2),
					customizacao_slime_rosa)
				pare
		}

		customizacao_desenhar_cores_cor_slime()
		g.definir_cor(janela_cor_fundo_interface)
		
		g.desenhar_retangulo(lar - 190, alt - 50, 175, 35, verdadeiro, verdadeiro)
		g.definir_cor(janela_cor_fundo)
		g.definir_tamanho_texto(18.0)
		g.desenhar_texto((lar - 100) - (g.altura_texto("A") * tx.numero_caracteres(lang_json("customizacao_de_personagem_concluido"))) / 2, alt - 42, lang_json("customizacao_de_personagem_concluido"))

		detectar_se_jogador_mudou_cor_slime()
		detectar_se_jogador_selecionou_botao_customizacao_de_personagem()
	}
	funcao configuracoes(){
		g.definir_cor(janela_cor_fundo_interface)
		g.definir_tamanho_texto(20.0)
		centralizar_texto((alt / 4) / 4, lang_json("menu_configuracoes"))

		// Desenha o botão de voltar
		g.definir_cor(janela_cor_fundo_interface)
		g.desenhar_retangulo(lar - 60, 10, 50, 27, falso, verdadeiro)
		g.definir_cor(janela_cor_conteudo_interface)
		g.definir_tamanho_texto(25.0)
		g.desenhar_texto(lar - 45, 12, ">")

		// Desenha os textos de configuração
		g.definir_cor(janela_cor_fundo_interface)
		g.definir_tamanho_texto(12.0)
		inteiro x = 25

		// Língua
		g.desenhar_texto(x, alt / 4, "Língua / language")
		g.desenhar_texto((lar - x) - (tx.numero_caracteres(configuracoes_lingua) * g.altura_texto("A")),
		alt / 4, configuracoes_lingua)

		// Música
		g.desenhar_texto(x, alt / 4 + g.altura_texto("A") * 2, lang_json("config_musica"))
		se(configuracoes_musica == falso){
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(lang_json("nao")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 2, lang_json("nao"))
		}
		senao{
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(lang_json("sim")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 2, lang_json("sim"))
		}

		// Efeitos sonoros
		g.desenhar_texto(x, alt / 4 + g.altura_texto("A") * 4, lang_json("config_efeitos_sonoros"))
		se(configuracoes_efeitos_sonoros == falso){
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(lang_json("nao")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 4, lang_json("nao"))
		}
		senao{
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(lang_json("sim")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 4, lang_json("sim"))
		}
		
		// Taxa de FPS máxima
		g.desenhar_texto(x, alt / 4 + g.altura_texto("A") * 6, lang_json("taxa_fps_maxima"))
		se(taxa_fps_maxima <= 0){
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(lang_json("nao")) * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 6, lang_json("nao"))
		}
		senao{
			g.desenhar_texto((lar - x) - (tx.numero_caracteres(taxa_fps_maxima + " FPS") * g.altura_texto("A")),
			alt / 4 + g.altura_texto("A") * 6, taxa_fps_maxima + " FPS")
		}
		
		escolha(detectar_se_jogador_selecionou_botao_configuracoes()){
			// Botão de voltar ao menu
			caso 0:
				tela_atual = MENU
				pare
			
			// Botão de escolha de idioma
			caso 1:
				se(configuracoes_lingua == "Português (BR)"){
					configuracoes_lingua = "English (US)"
				}
				senao{
					configuracoes_lingua = "Português (BR)"
				}
				pare

			// Botão de música
			caso 2:
				configuracoes_musica = nao configuracoes_musica
				pare

			// Botão de efeitos sonoros
			caso 3:
				configuracoes_efeitos_sonoros = nao configuracoes_efeitos_sonoros
				pare

			caso contrario:
				pare
		}
	}
	funcao erro_arquivos(){
		erro_carregamento_arquivos = verdadeiro

		// Define a cor de fundo
		g.definir_cor(janela_cor_fundo)
		g.limpar()
		
		// Escreve os textos informativos
		g.definir_cor(janela_cor_fundo_interface)
		centralizar_texto(alt / 4, "[!] FALHA NO CARREGAMENTO DOS ARQUIVOS DO JOGO [!]")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2, "Parece que há alguns arquivos faltando na pasta do jogo.")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 4, "1. Verifique se não mudou o diretório de alguma pasta ou arquivo;")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 6, "2. Verifique se não está faltando nenhuma pasta ou arquivo;")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 8, "3. Reinicie o jogo, pode ser que tenha ocorrido um bug.")
		centralizar_texto(alt / 2 - g.altura_texto("A") / 2 + g.altura_texto("A") * 12, "Pressione SHIFT + ESC para finalizar e verificar os arquivos.")
		g.renderizar()
		
		// Loop que aguarda o jogador finalizar o programa
		enquanto(nao(t.tecla_pressionada(t.TECLA_ESC) e t.tecla_pressionada(t.TECLA_SHIFT))){}
		finalizar()
		executando = falso
	}
	funcao tutorial(){
		// Exibe o texto do tutorial até que o jogador colete um ponto
		se(pontuacao == 0){
			g.definir_cor(0xffffff)
			g.definir_tamanho_texto(14.0)
			centralizar_texto(50, lang_json("tutorial_1"))
			centralizar_texto(50 + g.altura_texto("A") + 5, lang_json("tutorial_2"))
			centralizar_texto(50 + (g.altura_texto("A") + 5) * 2, lang_json("tutorial_3"))
			centralizar_texto(50 + (g.altura_texto("A") + 5) * 3, lang_json("tutorial_4"))
		}

		// Caso o jogador colete um ponto, o tutorial se finaliza
		senao{
			exibir_tutorial = falso
		}
	}
	funcao menu(){
		g.definir_tamanho_texto(12.0)
		
		// Define a cor do texto dos botôes
		g.definir_cor(janela_cor_fundo_interface)
		
		// Desenha o botão de jogar
		g.desenhar_imagem(lar / 2 - 75, alt / 2, menu_play_button)
		cadeia texto_play = lang_json("menu_jogar")
		g.desenhar_texto((lar / 2) - (g.altura_texto("A") * tx.numero_caracteres(texto_play)) / 2,
		lar / 2 - 82 + g.altura_imagem(menu_play_button), texto_play)
		
		// Desenha o botão de configurações
		g.desenhar_imagem(lar / 4 - 75, alt / 2 + 45, menu_config_button)
		cadeia texto_config = lang_json("menu_configuracoes")
		g.desenhar_texto((lar / 4 - 32) - (g.altura_texto("A") * tx.numero_caracteres(texto_config)) / 2,
		lar / 2 - 38 + g.altura_imagem(menu_config_button), texto_config)

		// Desenha o botão de sair
		g.desenhar_imagem(lar / 2 + lar / 4 - 32, alt / 2 + 45, menu_quit_button)
		cadeia texto_quit = lang_json("menu_sair")
		g.desenhar_texto((lar / 2 + lar / 4 + 15) - (g.altura_texto("A") * tx.numero_caracteres(texto_quit)) / 2,
		lar / 2 - 38 + g.altura_imagem(menu_quit_button), texto_quit)

		// Detecta se o jogador selecionou um botão do menu
		detectar_se_jogador_selecionou_botao_menu()
	}
	funcao jogo(){
		// Sorteia uma nova posição do ponto, caso necessário
		se(sortear_nova_posicao_ponto){
			sortear_nova_posicao_ponto = falso
			sortear_posicao_ponto()
		}
			
		// Funções referentes a eventos
		detectar_se_jogador_pegou_ponto()
			
		// Funções referentes a movimentação
		movimento_jogador()
		detectar_colisao_com_a_janela()
		
		// Funções referentes a desenhos
		desenhar_fase()
		desenhar_ponto()
		desenhar_jogador()
		desenhar_interface()
		
		// Inicia o tutorial, caso ainda não tenha sido iniciado
		se(exibir_tutorial){
			tutorial()
		}
	}

	// Funcões referentes à customização de personagem
	funcao customizacao_desenhar_cores_cor_slime(){
		inteiro cores[8] = {
			0xff3300,
			0xff9900,
			0xffff00,
			0x00cc66,
			0x0066ff,
			0x00ffff,
			0x9933ff,
			0xff3399
		}
		inteiro y = (alt / 2 + g.altura_imagem(customizacao_slime_vermelho) / 2) + 50
		
		g.definir_cor(cores[0])
		g.desenhar_retangulo(lar / 2 - 11 - (20 * 3) - (5 * 3), y, 20, 20, falso, verdadeiro)
		
		g.definir_cor(cores[1])
		g.desenhar_retangulo(lar / 2 - 11 - (20 * 2) - (5 * 2), y, 20, 20, falso, verdadeiro)
		
		g.definir_cor(cores[2])
		g.desenhar_retangulo(lar / 2 - 11 - (20 * 1) - (5 * 1), y, 20, 20, falso, verdadeiro)
		
		g.definir_cor(cores[3])
		g.desenhar_retangulo(lar / 2 - 12, y, 20, 20, falso, verdadeiro)
		
		g.definir_cor(cores[4])
		g.desenhar_retangulo(lar / 2 + 12, y, 20, 20, falso, verdadeiro)
		
		g.definir_cor(cores[5])
		g.desenhar_retangulo(lar / 2 + 11 + (20 * 1) + (5 * 1), y, 20, 20, falso, verdadeiro)
		
		g.definir_cor(cores[6])
		g.desenhar_retangulo(lar / 2 + 11 + (20 * 2) + (5 * 2), y, 20, 20, falso, verdadeiro)
		
		g.definir_cor(cores[7])
		g.desenhar_retangulo(lar / 2 + 11 + (20 * 3) + (5 * 3), y, 20, 20, falso, verdadeiro)
	}
	
	// Funções referentes ao ponto
	funcao sortear_posicao_ponto(){
		// Sorteia uma nova possição para o ponto
		inteiro sorteio_x = sorteia(0, lar - ponto_tamanho), sorteio_y = sorteia(25, alt - ponto_tamanho)
		ponto_posicao[0] = sorteio_x
		ponto_posicao[1] = sorteio_y
	}

	// Funções referentes à movimentação
	funcao movimento_jogador(){
		se(lar <= 750){
			jogador_velocidade = 1
		}
		senao{
			jogador_velocidade = 2
		}
		// Detecta se o jogador pressionou uma tecla
		se(t.tecla_pressionada(t.TECLA_W) ou t.tecla_pressionada(t.TECLA_SETA_ACIMA)){
			jogador_posicao[1] -= jogador_velocidade
		}
		se(t.tecla_pressionada(t.TECLA_A)  ou t.tecla_pressionada(t.TECLA_SETA_ESQUERDA)){
			jogador_posicao[0] -= jogador_velocidade
			jogador_virado_para_a_direita = falso
		}
		se(t.tecla_pressionada(t.TECLA_S) ou t.tecla_pressionada(t.TECLA_SETA_ABAIXO)){
			jogador_posicao[1] += jogador_velocidade
		}
		se(t.tecla_pressionada(t.TECLA_D) ou t.tecla_pressionada(t.TECLA_SETA_DIREITA)){
			jogador_posicao[0] += jogador_velocidade
			jogador_virado_para_a_direita = verdadeiro
		}
	}

	// Funções referentes à configurações
	funcao funcoes_teclado(){
		// Salva uma captura de tela na pasta do jogo
		se(t.tecla_pressionada(t.TECLA_F2)){
			inteiro tela = g.renderizar_imagem(lar, alt)
			g.salvar_imagem(tela, "/capturas de tela/captura" + c.hora_atual(falso) +
			c.minuto_atual() + c.segundo_atual() + c.milisegundo_atual() + c.dia_mes_atual()
			+ c.mes_atual() + c.ano_atual() + ".png")

			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
		}
		
		se(t.tecla_pressionada(t.TECLA_ESC) e (tela_atual == CUSTOMIZACAO_DE_PERSONAGEM ou tela_atual == JOGO)){
			tela_atual = MENU

			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
		}

		// Reseta o jogo atual e vai para a seleção de personagens
		se(tela_atual == JOGO e t.tecla_pressionada(t.TECLA_R)){
			pontuacao = 0
			jogador_posicao[0] = (lar / 2) - (jogador_tamanho[0] / 2)
			jogador_posicao[1] = (alt / 2) - (jogador_tamanho[1] / 2)
			jogador_virado_para_a_direita = verdadeiro
			sortear_nova_posicao_ponto = verdadeiro
			contador_tempo_obter_tempo = verdadeiro
			contador_tempo_minutos = 0
			tela_atual = CUSTOMIZACAO_DE_PERSONAGEM

			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
		}
		
		// Pausa o jogo
		se(tela_atual == JOGO e t.tecla_pressionada(t.TECLA_P)){
			g.definir_opacidade(155)
			g.definir_cor(0x404040)
			g.desenhar_retangulo(0, 0, lar, alt, falso, verdadeiro)
			g.definir_opacidade(255)
			g.definir_cor(janela_cor_fundo_interface)
			g.definir_tamanho_texto(45.0)
			centralizar_texto(alt / 2 - g.altura_texto("A") / 2, "PAUSADO")
			g.definir_tamanho_texto(14.0)
			centralizar_texto(alt / 2 + 25, "Pressione P para retornar ao jogo")
			g.renderizar()
			
			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
			
			// Loop que aguarda o jogador apertar novamente a tecla P
			enquanto(nao t.tecla_pressionada(t.TECLA_P)){}
			
			// Loop que evita excessivos cliques do jogador na mesma tecla, sem alterar o movimento do personagem
			enquanto(t.alguma_tecla_pressionada()){}
		}
	}
	funcao cadeia conteudo_arquivo_json(inteiro arquivo){
		cadeia json = ""
		enquanto(nao a.fim_arquivo(arquivo)){
			json += a.ler_linha(arquivo)
		}
		a.fechar_arquivo(arquivo)
		retorne "{" + json + "}"
	}
	funcao centralizar_texto(inteiro y, cadeia texto){
		inteiro x = 0
		x = (lar / 2) - (g.altura_texto("A") * tx.numero_caracteres(texto)) / 2
		g.desenhar_texto(x, y, texto)
	}
	funcao console(cadeia texto){
		escreva("[" + c.hora_atual(falso) + ":" + c.minuto_atual() +  " " + c.dia_mes_atual() + "/" + c.mes_atual() + "/" +  c.ano_atual() + "] " + texto + "\n")
	}
	funcao obter_fps(){
		// Aumenta a taxa de fps
		fps_taxa++

		// Obtem o tempo atual, quando necessário
		se(fps_obter_tempo){
			fps_tempo_inicio = u.tempo_decorrido()
			fps_obter_tempo = falso
		}

		// Detecta se já se passou 1 segundo desde a obtenção do tempo atual
		se((u.tempo_decorrido() - fps_tempo_inicio) / 1000 >= 1){
			fps_atual = fps_taxa
			fps_taxa = 0
			fps_obter_tempo = verdadeiro
		}
	}

	// Funções referentes à detecções
	funcao inteiro detectar_se_jogador_selecionou_botao_configuracoes(){
		inteiro x = m.posicao_x(), y = m.posicao_y()
		inteiro botao_pressionado = -1

		se(m.botao_pressionado(m.BOTAO_ESQUERDO)){
			// Botão de voltar ao menu
			se(x > lar - 60 e x < lar - 60 + 50 e y > 10 e y < 10 + 27){
				botao_pressionado = 0
			}

			// Botão de escolha de idioma
			senao se(y > alt / 4 e y < alt / 4 + g.altura_texto("A")){
				botao_pressionado = 1
			}
			
			// Botão de música
			senao se(y > alt / 4 + g.altura_texto("A") * 2 e y < alt / 4 + g.altura_texto("A") * 3){
				botao_pressionado = 2
			}
			
			// Botão de efeitos sonoros
			senao se(y > alt / 4 + g.altura_texto("A") * 4 e y < alt / 4 + g.altura_texto("A") * 5){
				botao_pressionado = 3
			}

			senao{
				retorne botao_pressionado
			}
			
			tocar_som_selecao_menu()
			
			// Loop que evita excessiovos cliques do jogador no mesmo botão
			enquanto(m.algum_botao_pressionado()){}
		}
		
		// Retorna um número equivalente a um botão da tela de configurações
		retorne botao_pressionado
	}
	funcao detectar_se_jogador_selecionou_botao_menu(){
		inteiro x = m.posicao_x(), y = m.posicao_y()
		se(m.botao_pressionado(m.BOTAO_ESQUERDO)){
			// Clique no botão de jogar
			se(x > lar / 2 - 75 e x < lar / 2 - 75 + g.largura_imagem(menu_play_button) e
			y > alt / 2 e y < alt / 2 + g.altura_imagem(menu_play_button)){
				tela_atual = CUSTOMIZACAO_DE_PERSONAGEM
			}

			// Clique no botão de configurações
			se(x > lar / 4 - 75 e x < lar / 4 - 75 + g.largura_imagem(menu_config_button) e
			y > alt / 2 + 45 e y < alt / 2 + 45 + g.altura_imagem(menu_config_button)){
				tela_atual = CONFIGURACOES
			}

			// Clique no botão de sair
			se(x > lar / 2 + lar / 4 - 32 e x < lar / 2 + lar / 4 - 32 + g.largura_imagem(menu_quit_button) e
			y > alt / 2 + 45 e y < alt / 2 + 45 + g.altura_imagem(menu_quit_button)){
				finalizar()
			}
		}
		
		// Loop que evita eventuais cliques excessivos do jogador
		enquanto(m.algum_botao_pressionado()){}
	}
	funcao detectar_se_jogador_selecionou_botao_customizacao_de_personagem(){
		inteiro x = m.posicao_x(), y = m.posicao_y()
		
		se(m.botao_pressionado(m.BOTAO_ESQUERDO)){
			// Clique no botão de concluir
			se(x > lar - 190 e x < lar - 190 + 175 e
			y > alt - 50 e y < alt - 50 + 35){
				tela_atual = JOGO
			}
		}
		
		// Loop que evita eventuais cliques excessivos do jogador
		enquanto(m.algum_botao_pressionado()){}
		
	}
	funcao detectar_se_jogador_mudou_cor_slime(){
		inteiro x = m.posicao_x(), y = m.posicao_y()
		inteiro cor_selecionada = -1

		se(y > (alt / 2 + g.altura_imagem(customizacao_slime_vermelho) / 2) + 50 e
		y < (alt / 2 + g.altura_imagem(customizacao_slime_vermelho) / 2) + 70 e m.botao_pressionado(m.BOTAO_ESQUERDO)){
			se(x > lar / 2 - 11 - (20 * 3) - (5 * 3) e x < lar / 2 - 11 - (20 * 3) - (5 * 3) + 20){
				cor_selecionada = 0
			}
			
			se(x > lar / 2 - 11 - (20 * 2) - (5 * 2) e x < lar / 2 - 11 - (20 * 2) - (5 * 2) + 20){
				cor_selecionada = 1
			}
			
			se(x > lar / 2 - 11 - (20 * 1) - (5 * 1) e x < lar / 2 - 11 - (20 * 1) - (5 * 1) + 20){
				cor_selecionada = 2
			}
			
			se(x > lar / 2 - 12 e x < lar / 2 - 12 + 20){
				cor_selecionada = 3
			}
			
			se(x > lar / 2 + 12 e x < lar / 2 + 12 + 20){
				cor_selecionada = 4
			}
			
			se(x > lar / 2 + 11 + (20 * 1) + (5 * 1) e x < lar / 2 + 11 + (20 * 1) + (5 * 1) + 20){
				cor_selecionada = 5
			}
			
			se(x > lar / 2 + 11 + (20 * 2) + (5 * 2) e x < lar / 2 + 11 + (20 * 2) + (5 * 2) + 20){
				cor_selecionada = 6
			}
			
			se(x > lar / 2 + 11 + (20 * 3) + (5 * 3) e x < lar / 2 + 11 + (20 * 3) + (5 * 3) + 20){
				cor_selecionada = 7
			}
		}

		escolha(cor_selecionada){
			caso 0:
				jogador_sprite = sprite_slime_vermelho
				jogador_cor = "vermelho"
				jogador_cor_numero = 0
				pare
				
			caso 1:
				jogador_sprite = sprite_slime_laranja
				jogador_cor = "laranja"
				jogador_cor_numero = 1
				pare
				
			caso 2:
				jogador_sprite = sprite_slime_amarelo
				jogador_cor = "amarelo"
				jogador_cor_numero = 2
				pare
				
			caso 3:
				jogador_sprite = sprite_slime_verde
				jogador_cor = "verde"
				jogador_cor_numero = 3
				pare
				
			caso 4:
				jogador_sprite = sprite_slime_azul
				jogador_cor = "azul"
				jogador_cor_numero = 4
				pare
				
			caso 5:
				jogador_sprite = sprite_slime_ciano
				jogador_cor = "ciano"
				jogador_cor_numero = 5
				pare
				
			caso 6:
				jogador_sprite = sprite_slime_roxo
				jogador_cor = "roxo"
				jogador_cor_numero = 6
				pare
				
			caso 7:
				jogador_sprite = sprite_slime_rosa
				jogador_cor = "rosa"
				jogador_cor_numero = 7
				pare
		}
	}
	funcao detectar_se_jogador_pegou_ponto(){
		// Variáveis que serão usadas para detectar se o jogador está realmente em cima do ponto
		logico x = falso, y = falso
		
		// Detecta se o jogador está em cima do ponto
		para(inteiro c = ponto_posicao[0]; c < ponto_posicao[0] + ponto_tamanho; c++){
			para(inteiro d = jogador_posicao[0]; d < jogador_posicao[0] + jogador_tamanho[0]; d++){
				se(d == c){
					x = verdadeiro
				}
			}
		}
		para(inteiro c = ponto_posicao[1]; c < ponto_posicao[1] + ponto_tamanho; c++){
			para(inteiro d = jogador_posicao[1]; d < jogador_posicao[1] + jogador_tamanho[1]; d++){
				se(d == c){
					y = verdadeiro
				}
			}
		}
		
		// Caso o jogador esteja em cima do ponto, a pontuação aumenta e uma nova posição do ponto é sorteada
		se(x e y){
			pontuacao++
			
			tocar_som_ponto_coletado()
			
			// Reseta a pontuação do jogador quando ele atinge um valor maior que 999 pontos
			se(pontuacao > 999){
				pontuacao = 0
			}
			
			sortear_nova_posicao_ponto = verdadeiro
		}
	}
	funcao detectar_colisao_com_a_janela(){
		// Detecta se o jogador saiu para fora da janela e o coloca novamente na janela
		se(jogador_posicao[1] < 25){
			jogador_posicao[1] += jogador_velocidade
		}
		se(jogador_posicao[1] > alt - jogador_tamanho[1]){
			jogador_posicao[1] -= jogador_velocidade
		}
		se(jogador_posicao[0] < 0){
			jogador_posicao[0] += jogador_velocidade
		}
		se(jogador_posicao[0] > lar - jogador_tamanho[0]){
			jogador_posicao[0] -= jogador_velocidade
		}
	}

	// Funções referentes aos sons
	funcao tocar_som_ponto_coletado(){
		se(configuracoes_efeitos_sonoros){
			escolha(sorteia(1, 2)){
				caso 1:
					s.reproduzir_som(som_point_collected1, falso)
					pare
				
				caso 2:
					s.reproduzir_som(som_point_collected2, falso)
					pare
			}
		}
	}
	funcao tocar_som_selecao_menu(){
		se(configuracoes_efeitos_sonoros){
			s.reproduzir_som(som_button_click, falso)
		}
	}
	
	// Funções referentes à interface
	funcao cadeia interface_obter_tempo(){		
		// Obtem um tempo para servir de base na primeira vez que a função é executada
		se(contador_tempo_obter_tempo){
			contador_tempo_inicio = u.tempo_decorrido()
			contador_tempo_obter_tempo = falso
		}

		// Detecta se passou 1 minuto
		inteiro contador_tempo = (u.tempo_decorrido() - contador_tempo_inicio) / 1000
		se(contador_tempo >= 60){
			contador_tempo_minutos++
			contador_tempo_obter_tempo = verdadeiro
		}

		// Coloca 0(zero(s)) na frente dos segundos
		cadeia contador_tempo_cadeia = contador_tempo + ""
		se(contador_tempo < 10){
			contador_tempo_cadeia = "0" + contador_tempo
		}
		
		// Retorna o tempo, em uma cadeia
		retorne contador_tempo_cadeia
	}
	funcao interface_desenhar_pontuacao(){
		cadeia pontos = pontuacao + "", maior_pontos = maior_pontuacao + ""
		
		// Coloca 0(zero(s)) na frente das pontuações, caso as pontuações forem menores que 100 e/ou 10
		se(pontuacao < 100 e pontuacao < 10){
			pontos = "00" + pontos
		}
		senao se(pontuacao < 100 e pontuacao >= 10){
			pontos = "0" + pontos
		}
		
		// Desenha a pontuação do jogador
		g.definir_tamanho_texto(14.0)
		g.desenhar_texto(10, 7, pontos)
	}
	funcao interface_desenhar_fps(){
		g.desenhar_texto(lar - 10 - (g.altura_texto("A") * tx.numero_caracteres("FPS: " + fps_atual)),
		7, "FPS: " + fps_atual)
	}

	// Funções referentes à carregar arquivos
	funcao carregar_todos_os_arquivos(){
		desenhar_texto_carregamento_de_arquivos("Fontes")
		carregar_fontes()
		desenhar_texto_carregamento_de_arquivos("Sons")
		carregar_sons()
		desenhar_texto_carregamento_de_arquivos("Arquivos")
		carregar_arquivos()
		desenhar_texto_carregamento_de_arquivos("Imagens")
		carregar_imagens()
	}
	funcao carregar_arquivos(){
		// Carrega o arquivo de configurações
		se(a.arquivo_existe(pasta_config + "/config.config")){
			arquivo_configuracoes = a.abrir_arquivo(pasta_config + "/config.config", a.MODO_LEITURA)

			// Lê se o tutorial já foi exibido
			cadeia linha = a.ler_linha(arquivo_configuracoes)
			se(linha == "tutorial_exibido: false;"){
				exibir_tutorial = verdadeiro
			}
		}
		senao{
			erro_arquivos()
		}
		
		console("Arquivos: arquivos carregados.")
		
		// Carrega os arquivos referentes a idiomas
		se(a.arquivo_existe(pasta_lang + "/pt_br.lang") e a.arquivo_existe(pasta_lang + "/en_us.lang")){
			pt_br = a.abrir_arquivo(pasta_lang + "/pt_br.lang", a.MODO_LEITURA)
			en_us = a.abrir_arquivo(pasta_lang + "/en_us.lang", a.MODO_LEITURA)
			
			cadeia obj_lang_pt_br = ""
			enquanto(nao a.fim_arquivo(pt_br)){
				obj_lang_pt_br += a.ler_linha(pt_br)
			}
			lang_pt_br = o.criar_objeto_via_json("{" + obj_lang_pt_br + "}")

			cadeia obj_lang_en_us = ""
			enquanto(nao a.fim_arquivo(en_us)){
				obj_lang_en_us += a.ler_linha(en_us)
			}
			lang_en_us = o.criar_objeto_via_json("{" + obj_lang_en_us + "}")

			console("Arquivos: arquivos de idioma carregados.")
		}
		senao{
			erro_arquivos()
		}
		
		se(nao erro_carregamento_arquivos){
			a.fechar_arquivo(arquivo_configuracoes)
			a.fechar_arquivo(pt_br)
			a.fechar_arquivo(en_us)
		}
	}
	funcao carregar_imagens(){
		menu_play_button = g.carregar_imagem(pasta_menus + "/buttons/play_button.png")
		menu_config_button = g.carregar_imagem(pasta_menus + "/buttons/config_button.png")
		menu_quit_button = g.carregar_imagem(pasta_menus + "/buttons/quit_button.png")
		sprite_fantasma_cinza = g.carregar_imagem(pasta_sprites + "/fantasma_cinza.png")
		customizacao_slime_vermelho = g.carregar_imagem(pasta_customizacao + "/slime_vermelho.png")
		customizacao_slime_laranja = g.carregar_imagem(pasta_customizacao + "/slime_laranja.png")
		customizacao_slime_amarelo = g.carregar_imagem(pasta_customizacao + "/slime_amarelo.png")
		customizacao_slime_verde = g.carregar_imagem(pasta_customizacao + "/slime_verde.png")
		customizacao_slime_azul = g.carregar_imagem(pasta_customizacao + "/slime_azul.png")
		customizacao_slime_ciano = g.carregar_imagem(pasta_customizacao + "/slime_ciano.png")
		customizacao_slime_roxo = g.carregar_imagem(pasta_customizacao + "/slime_roxo.png")
		customizacao_slime_rosa = g.carregar_imagem(pasta_customizacao + "/slime_rosa.png")
		sprite_slime_vermelho = g.carregar_imagem(pasta_sprites + "/slime_vermelho.png")
		sprite_slime_laranja = g.carregar_imagem(pasta_sprites + "/slime_laranja.png")
		sprite_slime_amarelo = g.carregar_imagem(pasta_sprites + "/slime_amarelo.png")
		sprite_slime_verde = g.carregar_imagem(pasta_sprites + "/slime_verde.png")
		sprite_slime_azul = g.carregar_imagem(pasta_sprites + "/slime_azul.png")
		sprite_slime_ciano = g.carregar_imagem(pasta_sprites + "/slime_ciano.png")
		sprite_slime_roxo = g.carregar_imagem(pasta_sprites + "/slime_roxo.png")
		sprite_slime_rosa = g.carregar_imagem(pasta_sprites + "/slime_rosa.png")
		
		console("Imagens: imagens carregadas.")
	}
	funcao carregar_fontes(){
		// Carrega as fontes
		g.carregar_fonte(pasta_fonts + "/PressStart2P.ttf")
		g.definir_fonte_texto("Press Start 2P")
		
		console("Fontes: fontes carregadas.")
	}
	funcao carregar_sons(){
		som_button_click = s.carregar_som(pasta_sons + "/sfx/button_click.mp3")
		som_point_collected1 = s.carregar_som(pasta_sons + "/sfx/point_collected1.mp3")
		som_point_collected2 = s.carregar_som(pasta_sons + "/sfx/point_collected2.mp3")
		console("Sons: sons carregados.")
	}

	// Funções referentes à liberar arquivos
	funcao liberar_imagens(){
		g.liberar_imagem(menu_play_button)
		g.liberar_imagem(menu_config_button)
		g.liberar_imagem(menu_quit_button)
		g.liberar_imagem(sprite_fantasma_cinza)
		g.liberar_imagem(customizacao_slime_vermelho)
		g.liberar_imagem(customizacao_slime_laranja)
		g.liberar_imagem(customizacao_slime_amarelo)
		g.liberar_imagem(customizacao_slime_verde)
		g.liberar_imagem(customizacao_slime_azul)
		g.liberar_imagem(customizacao_slime_ciano)
		g.liberar_imagem(customizacao_slime_roxo)
		g.liberar_imagem(customizacao_slime_rosa)
		g.liberar_imagem(sprite_slime_vermelho)
		g.liberar_imagem(sprite_slime_laranja)
		g.liberar_imagem(sprite_slime_amarelo)
		g.liberar_imagem(sprite_slime_verde)
		g.liberar_imagem(sprite_slime_azul)
		g.liberar_imagem(sprite_slime_ciano)
		g.liberar_imagem(sprite_slime_roxo)
		g.liberar_imagem(sprite_slime_rosa)
	}
	funcao liberar_sons(){
		s.liberar_som(som_button_click)
		s.liberar_som(som_point_collected1)
		s.liberar_som(som_point_collected2)
	}

	// Funções referentes à lingua do jogo
	funcao cadeia lang_json(cadeia propriedade){
		retorne o.obter_propriedade_tipo_cadeia(lingua_escolhida(), propriedade)
	}
	funcao inteiro lingua_escolhida(){
		se(configuracoes_lingua == "Português (BR)"){
			retorne lang_pt_br
		}
		senao se(configuracoes_lingua == "English (US)"){
			retorne lang_en_us
		}
		senao{
			retorne lang_pt_br
		}
	}

	// Funções referentes às fases
	funcao desenhar_fase(){
		definir_tipo_da_fase()
		desenhar_objetos_fase()
	}
	funcao definir_tipo_da_fase(){
		cadeia tipo_da_fase = o.obter_propriedade_tipo_cadeia(objeto_json_fase(1), "tipo")
		se(tipo_da_fase == "grama"){
			g.definir_cor(g.COR_VERDE)
		}
	}
	funcao desenhar_objetos_fase(){
		
	}
	funcao inteiro objeto_json_fase(inteiro numero_fase){
		retorne o.criar_objeto_via_json(conteudo_arquivo_json(a.abrir_arquivo(pasta_fases + "/fase" + numero_fase + ".json", a.MODO_LEITURA)))
	}
}
