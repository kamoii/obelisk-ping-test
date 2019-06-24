{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
module Backend where

import Common.Route
import Obelisk.Backend
import Obelisk.Route
import Snap

backend :: Backend BackendRoute FrontendRoute
backend = Backend
  { _backend_run = \serve -> serve $ \case
      BackendRoute_Missing :/ () -> pure ()
      BackendRoute_Ping :/ () -> writeBS "pong"
  , _backend_routeEncoder = backendRouteEncoder
  }
