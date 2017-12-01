# at least list here files in the order you want them to run

.PHONY: all
all:
	Rscript R/data/make_dataset.R
	Rscript R/features/build_features.R
	Rscript R/models/predict_model.R
	Rscript R/models/train_model.R


