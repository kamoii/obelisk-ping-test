{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE PartialTypeSignatures #-}
module Frontend where

import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Obelisk.Frontend
import Obelisk.Configs
import Obelisk.Route
import Reflex.Dom.Core
import Data.Functor.Identity

import Common.Api
import Common.Route
import Obelisk.Generated.Static

frontend :: Frontend (R FrontendRoute)
frontend = Frontend
  { _frontend_head = el "title" $ text "Obelisk Minimal Example"
  , _frontend_body = prerender_ blank $ do
      el "h1" $ text "Backend request test."
      evBtn <- el "div" $ button "ping"
      dyPingCount <- count evBtn
      el "div" $ do
        text "ping count: "
        dynText $ T.pack . show <$> dyPingCount
      evPong <- ping evBtn
      dyPongCount <- count evPong
      el "div" $ do
        text "pong count: "
        dynText $ T.pack . show <$> dyPongCount
      pure ()
  }

ping :: _ => Event t () -> m (Event t ())
ping evInput = do
  res <- getApi BackendRoute_Ping evInput
  pure $ () <$ res

getApi
  :: _
  => BackendRoute param
  -> Event t param
  -> m (Event t XhrResponse)
getApi r evInput = performRequestAsync $ fmap mkXhrReq evInput
  where
    mkXhrReq param =
      let url = renderBackendRoute _enc (r :/ param)
      in xhrRequest "GET" url def

    _enc :: Encoder Identity Identity _ _
    Right _enc = checkEncoder backendRouteEncoder
