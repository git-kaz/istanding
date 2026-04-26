module ReportsHelper
  # 運動回数と座位時間の複合グラフを生成
  def activity_mixed_chart(reports, title: nil)
    # 　運動の最大を取得してメモリのスケールを調整
    max_exercise = reports.map { |r| r[:exercise_count].to_i }.max || 0
    exercise_max_axis = max_exercise <= 5 ? 10 : (max_exercise * 1.2).ceil

    # 　合計座位時間の最大を取得してメモリのスケールを調整
    max_total_duration = reports.map { |r| r[:total_duration_hours].to_f }.max || 0
    total_duration_max_axis = (max_total_duration * 1.2).ceil


    column_chart [
      {
        name: "合計座位時間(h)",
        data: reports.map { |r| [ r[:date_label], r[:total_duration_hours] ] },
        color: "#6A9B76",
        library: {
          type: "line",
          yAxisID: "y",
          tension: 0.4,
          borderWidth: 3 }
      },
      {
        name: "運動回数(回)",
        data: reports.map { |r| [ r[:date_label], r[:exercise_count] ] },
        color: "#E07A5F",
        type: "line",
        library: { yAxisID: "y1" }
      }
    ],
    title: title,
    library: {
      scales: {
        'y': {
          position: "left",
          min: 0,
          max: total_duration_max_axis,
          title: { display: true, text: "時間(h)" },
          grid: { display: true }
        },
        'y1': {
          position: "right",
          min: 0,
          max: exercise_max_axis,
          grid: { drawOnChartArea: false },
          title: { display: true, text: "回数(回)" }
        }
      }
    }
  end

end
