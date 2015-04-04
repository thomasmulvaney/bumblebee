(ns bumblebee.table
  (require bumblebee.stat :as stat))

(def horizontal
  ^{:private true}
  "─")
(def vertical
  ^{:private true}
  "│")

(def left-corner
  ^{:private true}
  {:top    "┌"
   :inner  "├"
   :bottom "└"})

(def inner-corner
  ^{:private true}
  {:top    "┬"
   :inner  "┼"
   :bottom "┴"})

(def right-corner
  ^{:private true}
  {:top    "┐"
   :inner  "┤"
   :bottom "┘"})

(defn- display [s]
  (str " " s " "))

(defn- column-width [xs]
  (stat/max (map (comp count display) xs)))

(defn- header-entry [header]
  (reduce #(assoc %1 %2 (name %2)) {} header))

(defn- make-row [widths vertical-location]
  (let [stretches (map #(apply str (repeat % horizontal)) widths)]
    (str (vertical-location left-corner)
         (apply str (interpose (vertical-location inner-corner) stretches))
         (vertical-location right-corner))))

(defn- pad [s width]
  (let [padding-needed (- width (count s))
        padding (repeat padding-needed " ")]
    (str (apply str padding)
         s)))

(defn- row-str [row widths header]
  (let [padded (map #(pad (display (%1 row)) %2) header widths)]
  (str vertical
       (apply str (interpose vertical padded))
       vertical
       \newline)))

(defn create [header rows]
  (let [columns (map #(concat [(name %)] (map % rows)) header)
        widths (map column-width columns)
        rows (concat [(header-entry header)] rows)]
    (str
      (make-row widths :top)
      (apply str \newline
             (interpose (str (make-row widths :inner) \newline)
                        (map #(row-str % widths header) rows)))
      (make-row widths :bottom))))
