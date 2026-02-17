module Bot
  module Handlers
    class InventoryItems < Bot::Handlers::Base
      @@current_setting = []

      def initialize(chat_id, username)
        super(chat_id)

        @username = username
      end

      def perform(**args)
        if args.include? :message
          perform_steam_id(args[:message])
        else
          if @user.inventory.nil?
            perform_request_steam_id
          else
            perform_send_inventory
          end
        end
      end

      def self.setting?(chat_id)
        $bot.logger.debug(
          "Setting in #{@@current_setting} with #{chat_id} is #{@@current_setting.include? chat_id}"
        )
        @@current_setting.include? chat_id
      end

      private

      def perform_send_inventory
        @user.inventory.update_items
        send_inventory(@user.inventory.report)
      end

      def perform_request_steam_id
        $bot.logger.debug("User uid=\"#{@user.tg_id}\" start setting inventory")

        @@current_setting << @user.tg_id
        ask_steam_id
      end

      def perform_steam_id(steam_id)
        return notice_unknown unless self.class.setting?(@user.tg_id)
        $bot.logger.debug("User uid=\"#{@user.tg_id}\" send steam_id=\"#{steam_id}\"")

        res = SteamAPI::Inventory::Request.new(steam_id).send
        
        unless res.success?
          send_error
        else
          inventory = Inventory.find_or_create_by(user: @user)
          inventory.fill(res.items)

          send_inventory(@user.inventory.report)
          # send_inventory(inventory.items.to_a)
        end
        
        @@current_setting.delete(@user.tg_id)
      end

      def ask_steam_id
        Bot::Messages::AskSteamId.send(chat_id: @user.tg_id, username: @username)
      end

      def send_error
        Bot::Messages::AddSteamIdError.send(chat_id: @user.tg_id, username: @username)
      end

      def send_inventory(report)
        Bot::Messages::Inventory.send(
          chat_id: @user.tg_id,
          username: @username,
          report: report
        )
      end
    end
  end
end
