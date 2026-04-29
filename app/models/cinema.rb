class Cinema < ApplicationRecord
  belongs_to :bairro
  belongs_to :edicao
  has_many :programacoes

  def filter_value
    id
  end

  def filter_display(locale: I18n.locale)
    nome
  end

  def display_capacidade
    capacidade.present? ? "#{capacidade} lugares" : "TDB"
  end

  class << self
    def group_salas(cinemas)
      cinemas
        .group_by { |c| complex_name_from_record_name(c.nome) }
        .map { |complex_name, salas| build_complex_row(complex_name, salas) }
    end

    private

    def complex_name_from_record_name(full_name)
      full_name.match(/\A\D*/).to_s.strip
    end

    def build_complex_row(complex_name, salas)
      first = salas.first
      row = { name: complex_name, cinema: first }

      if salas.many?
        row[:salas] = salas.map do |sala|
          {
            nome: "Sala #{sala_number_from_record_name(sala.nome)}",
            capacidade: sala.display_capacidade
          }
        end
      else
        row[:capacidade] = first.display_capacidade
      end

      row
    end

    def sala_number_from_record_name(full_name)
      full_name[/\d+/]
    end
  end
end
