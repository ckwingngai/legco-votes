class CreateVoteHists < ActiveRecord::Migration[5.0]
  def change
    create_table :vote_hists do |t|
      t.string :data
      t.date :vote_date

      t.timestamps
    end
  end
end
