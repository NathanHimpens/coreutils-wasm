# frozen_string_literal: true

require 'net/http'
require 'json'
require 'fileutils'
require 'uri'

module CoreutilsWasm
  class Downloader
    REPO_OWNER = 'NathanHimpens'
    REPO_NAME  = 'coreutils-wasm'
    ASSET_NAME = 'coreutils.wasm'

    class << self
      def download(to:)
        target = File.expand_path(to)
        FileUtils.mkdir_p(File.dirname(target))

        begin
          tag = get_latest_release_tag
          download_asset(tag, target)
          FileUtils.chmod(0o755, target)
          true
        rescue StandardError => e
          FileUtils.rm_f(target)
          warn "Download failed: #{e.message}"
          raise
        end
      end

      private

      def get_latest_release_tag
        uri = URI("https://api.github.com/repos/#{REPO_OWNER}/#{REPO_NAME}/releases/latest")
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data['tag_name']
      end

      def download_asset(tag, target)
        uri = URI("https://github.com/#{REPO_OWNER}/#{REPO_NAME}/releases/download/#{tag}/#{ASSET_NAME}")

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          request = Net::HTTP::Get.new(uri)
          http.request(request) do |response|
            if response.is_a?(Net::HTTPRedirection)
              return download_from_uri(URI(response['location']), target)
            end

            File.open(target, 'wb') do |file|
              response.read_body do |chunk|
                file.write(chunk)
              end
            end
          end
        end
      end

      def download_from_uri(uri, target)
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new(uri)
          http.request(request) do |response|
            File.open(target, 'wb') do |file|
              response.read_body do |chunk|
                file.write(chunk)
              end
            end
          end
        end
      end
    end
  end
end
