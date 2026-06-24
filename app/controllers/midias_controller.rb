# frozen_string_literal: true

class MidiasController < ApplicationController
  def index
    redirect_to midias_fotos_e_videos_path
  end

  def fotos_e_videos
    render inertia: "Midias/FotosEVideos", props: {
      title: fotos_e_videos_label,
      activePage: fotos_e_videos_label,
      galleryLink: {
        label: "Ir para Flickr do Festival",
        href: "https://www.flickr.com/photos/festivaldorio/"
      },
      youtubeLink: {
        label: "Ir para YouTube do Festival",
        href: "https://www.youtube.com/@FestivaldoRio"
      },
      heroPhoto: {
        title: "Troféu Redentor",
        caption: "Troféu Redentor",
        imageKey: "trofeu-redentor"
      },
      videos: [
        {
          title: "TV Festival",
          embedUrl: nil
        },
        {
          title: "Entrevistas do Festival",
          embedUrl: nil
        }
      ]
    }
  end

  def impressos
    render inertia: "Midias/Impressos", props: {
      title: impressos_label,
      activePage: impressos_label,
      printMaterials: [
        {
          title: "Revista de programação",
          cta: "Abrir PDF",
          pdfUrl: nil,
          coverImageKey: "revista-programacao",
          coverAlt: "Capa da revista de programação"
        },
        {
          title: "Catálogo oficial",
          cta: "Abrir PDF",
          pdfUrl: nil,
          coverImageKey: "catalogo-oficial",
          coverAlt: "Capa do catálogo oficial"
        },
        {
          title: "Cartazes",
          cta: "Abrir PDF",
          pdfUrl: nil,
          coverImageKey: "cartazes",
          coverAlt: "Cartaz do Festival do Rio"
        }
      ]
    }
  end

  private

  def fotos_e_videos_label
    I18n.t("navigation.media.fotos_e_videos")
  end

  def impressos_label
    I18n.t("navigation.media.impressos")
  end
end
