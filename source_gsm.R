## Source to script: Calc Surface Metrics

## One raster
calculate_gsm_local <- function(r){
  
  ## sa: Calculates the Average Roughness of a Surface
  ## Finds the average roughness of a surface (Sa) as the absolute deviation of surface heights from the
  ## mean surface height. 
  GSM_sa <- sa(r)
  
  ## ssk: Calculates the Skewness of Raster Values
  ## Skewness represents the asymmetry of the surface height distribution. 
  GSM_ssk <- ssk(r, adj = TRUE)
  
  ## std: Texture Direction Metrics
  ## Calculates the angle of dominating texture and the texture direction index of the Fourier spectrum
  ## image calculated from a raster image (see Kedron et al. 2018)
  
  # calculate Std and Stdi
  GSM_stdvals <- std(r)
  
  # extract each value
  GSM_std <- GSM_stdvals[1]
  GSM_stdi <- GSM_stdvals[2]
  
  result <- data.frame(sa=GSM_sa, ssk=GSM_ssk, std=GSM_std, stdi=GSM_stdi)
  
  return(result)
  
}

## Loop for a list of rasters
## Calculate gradient surface metrics

calculate_gsm <- function(clip) {
  
  metrics <- purrr::map(seq_along(clip), function(x) {
    
    total_clip <- length(clip)
    
    print(paste0("Progress: ", x, " from ", total_clip))
    
    
    ## Create list and tibble
    resL <- list()
    res <-  tibble(sample = names(clip[[x]]), 
                   sa = as.numeric(0), 
                   s10 = as.numeric(0),
                   ssk = as.numeric(0),
                   sdr = as.numeric(0),
                   std = as.numeric(0),
                   stdi = as.numeric(0),
                   srwi = as.numeric(0),
                   sfd = as.numeric(0),
                   sbi = as.numeric(0)) ## you can add other columns here
    
    ## sa: Calculates the Average Roughness of a Surface
    res[ , 2] <- sa(clip[[x]])
    
    ##s10: Ten-Point Height
    res[ , 3] <- s10z(clip[[x]])
    
    ## ssk: Calculates the Skewness of Raster Values
    res[ , 4] <- ssk(clip[[x]], adj = TRUE)
    
    ## sdr: Surface Area Ratio
    res[ , 5] <- sdr(clip[[x]])
    
    # calculate Std and Stdi
    stdvals <- std(clip[[x]])
    res[ , 6] <- stdvals[1]
    res[ , 7] <- stdvals[2]
    
    # srw: Radial Wavelength Metrics
    srwvals <- srw(clip[[x]], plot = FALSE)
    res[ , 8] <- srwvals[1]
    
    # sfd: Calculate the fractal dimension of a raster
    res[ , 9] <- sfd(clip[[x]], silent = T)
    
    # sbi: Surface Bearing Index
    res[ , 10] <- sbi(clip[[x]])
    
    ## Save values
    resL[[x]] <- res
    
    ## Merge all dataframes
    resF <- dplyr::bind_rows(resL, .id = NULL)
    
    return(resF)
    
  })
  
}




