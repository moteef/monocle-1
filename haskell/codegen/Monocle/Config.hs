{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- | Generated by Haskell protocol buffer compiler. DO NOT EDIT!
module Monocle.Config where

import Control.Applicative ((<$>), (<*>), (<|>))
import qualified Control.Applicative as Hs
import qualified Control.DeepSeq as Hs
import qualified Control.Monad as Hs
import qualified Data.ByteString as Hs
import qualified Data.Coerce as Hs
import qualified Data.Int as Hs (Int16, Int32, Int64)
import qualified Data.List.NonEmpty as Hs (NonEmpty (..))
import qualified Data.Map as Hs (Map, mapKeysMonotonic)
import qualified Data.Proxy as Proxy
import qualified Data.String as Hs (fromString)
import qualified Data.Text.Lazy as Hs (Text)
import qualified Data.Vector as Hs (Vector)
import qualified Data.Word as Hs (Word16, Word32, Word64)
import qualified GHC.Enum as Hs
import qualified GHC.Generics as Hs
import qualified Proto3.Suite.Class as HsProtobuf
import qualified Proto3.Suite.DotProto as HsProtobuf
import Proto3.Suite.JSONPB ((.:), (.=))
import qualified Proto3.Suite.JSONPB as HsJSONPB
import qualified Proto3.Suite.Types as HsProtobuf
import qualified Proto3.Wire as HsProtobuf
import qualified Unsafe.Coerce as Hs
import qualified Prelude as Hs

data ProjectDefinition = ProjectDefinition
  { projectDefinitionName ::
      Hs.Text,
    projectDefinitionRepositoryRegex :: Hs.Text,
    projectDefinitionBranchRegex :: Hs.Text,
    projectDefinitionFileRegex :: Hs.Text
  }
  deriving (Hs.Show, Hs.Eq, Hs.Ord, Hs.Generic, Hs.NFData)

instance HsProtobuf.Named ProjectDefinition where
  nameOf _ = (Hs.fromString "ProjectDefinition")

instance HsProtobuf.HasDefault ProjectDefinition

instance HsProtobuf.Message ProjectDefinition where
  encodeMessage
    _
    ProjectDefinition
      { projectDefinitionName = projectDefinitionName,
        projectDefinitionRepositoryRegex =
          projectDefinitionRepositoryRegex,
        projectDefinitionBranchRegex = projectDefinitionBranchRegex,
        projectDefinitionFileRegex = projectDefinitionFileRegex
      } =
      ( Hs.mconcat
          [ ( HsProtobuf.encodeMessageField
                (HsProtobuf.FieldNumber 1)
                projectDefinitionName
            ),
            ( HsProtobuf.encodeMessageField
                (HsProtobuf.FieldNumber 2)
                projectDefinitionRepositoryRegex
            ),
            ( HsProtobuf.encodeMessageField
                (HsProtobuf.FieldNumber 3)
                projectDefinitionBranchRegex
            ),
            ( HsProtobuf.encodeMessageField
                (HsProtobuf.FieldNumber 4)
                projectDefinitionFileRegex
            )
          ]
      )
  decodeMessage _ =
    (Hs.pure ProjectDefinition)
      <*> ( HsProtobuf.at
              HsProtobuf.decodeMessageField
              (HsProtobuf.FieldNumber 1)
          )
      <*> ( HsProtobuf.at
              HsProtobuf.decodeMessageField
              (HsProtobuf.FieldNumber 2)
          )
      <*> ( HsProtobuf.at
              HsProtobuf.decodeMessageField
              (HsProtobuf.FieldNumber 3)
          )
      <*> ( HsProtobuf.at
              HsProtobuf.decodeMessageField
              (HsProtobuf.FieldNumber 4)
          )
  dotProto _ =
    [ ( HsProtobuf.DotProtoField
          (HsProtobuf.FieldNumber 1)
          (HsProtobuf.Prim HsProtobuf.String)
          (HsProtobuf.Single "name")
          []
          ""
      ),
      ( HsProtobuf.DotProtoField
          (HsProtobuf.FieldNumber 2)
          (HsProtobuf.Prim HsProtobuf.String)
          (HsProtobuf.Single "repository_regex")
          []
          ""
      ),
      ( HsProtobuf.DotProtoField
          (HsProtobuf.FieldNumber 3)
          (HsProtobuf.Prim HsProtobuf.String)
          (HsProtobuf.Single "branch_regex")
          []
          ""
      ),
      ( HsProtobuf.DotProtoField
          (HsProtobuf.FieldNumber 4)
          (HsProtobuf.Prim HsProtobuf.String)
          (HsProtobuf.Single "file_regex")
          []
          ""
      )
    ]

instance HsJSONPB.ToJSONPB ProjectDefinition where
  toJSONPB (ProjectDefinition f1 f2 f3 f4) =
    ( HsJSONPB.object
        [ "name" .= f1,
          "repository_regex" .= f2,
          "branch_regex" .= f3,
          "file_regex" .= f4
        ]
    )
  toEncodingPB (ProjectDefinition f1 f2 f3 f4) =
    ( HsJSONPB.pairs
        [ "name" .= f1,
          "repository_regex" .= f2,
          "branch_regex" .= f3,
          "file_regex" .= f4
        ]
    )

instance HsJSONPB.FromJSONPB ProjectDefinition where
  parseJSONPB =
    ( HsJSONPB.withObject
        "ProjectDefinition"
        ( \obj ->
            (Hs.pure ProjectDefinition) <*> obj .: "name"
              <*> obj .: "repository_regex"
              <*> obj .: "branch_regex"
              <*> obj .: "file_regex"
        )
    )

instance HsJSONPB.ToJSON ProjectDefinition where
  toJSON = HsJSONPB.toAesonValue
  toEncoding = HsJSONPB.toAesonEncoding

instance HsJSONPB.FromJSON ProjectDefinition where
  parseJSON = HsJSONPB.parseJSONPB

instance HsJSONPB.ToSchema ProjectDefinition where
  declareNamedSchema _ =
    do
      let declare_name = HsJSONPB.declareSchemaRef
      projectDefinitionName <- declare_name Proxy.Proxy
      let declare_repository_regex = HsJSONPB.declareSchemaRef
      projectDefinitionRepositoryRegex <-
        declare_repository_regex
          Proxy.Proxy
      let declare_branch_regex = HsJSONPB.declareSchemaRef
      projectDefinitionBranchRegex <- declare_branch_regex Proxy.Proxy
      let declare_file_regex = HsJSONPB.declareSchemaRef
      projectDefinitionFileRegex <- declare_file_regex Proxy.Proxy
      let _ =
            Hs.pure ProjectDefinition <*> HsJSONPB.asProxy declare_name
              <*> HsJSONPB.asProxy declare_repository_regex
              <*> HsJSONPB.asProxy declare_branch_regex
              <*> HsJSONPB.asProxy declare_file_regex
      Hs.return
        ( HsJSONPB.NamedSchema
            { HsJSONPB._namedSchemaName =
                Hs.Just "ProjectDefinition",
              HsJSONPB._namedSchemaSchema =
                Hs.mempty
                  { HsJSONPB._schemaParamSchema =
                      Hs.mempty
                        { HsJSONPB._paramSchemaType =
                            Hs.Just HsJSONPB.SwaggerObject
                        },
                    HsJSONPB._schemaProperties =
                      HsJSONPB.insOrdFromList
                        [ ("name", projectDefinitionName),
                          ( "repository_regex",
                            projectDefinitionRepositoryRegex
                          ),
                          ( "branch_regex",
                            projectDefinitionBranchRegex
                          ),
                          ( "file_regex",
                            projectDefinitionFileRegex
                          )
                        ]
                  }
            }
        )

newtype GetProjectsRequest = GetProjectsRequest
  { getProjectsRequestIndex ::
      Hs.Text
  }
  deriving (Hs.Show, Hs.Eq, Hs.Ord, Hs.Generic, Hs.NFData)

instance HsProtobuf.Named GetProjectsRequest where
  nameOf _ = (Hs.fromString "GetProjectsRequest")

instance HsProtobuf.HasDefault GetProjectsRequest

instance HsProtobuf.Message GetProjectsRequest where
  encodeMessage
    _
    GetProjectsRequest
      { getProjectsRequestIndex =
          getProjectsRequestIndex
      } =
      ( Hs.mconcat
          [ ( HsProtobuf.encodeMessageField
                (HsProtobuf.FieldNumber 1)
                getProjectsRequestIndex
            )
          ]
      )
  decodeMessage _ =
    (Hs.pure GetProjectsRequest)
      <*> ( HsProtobuf.at
              HsProtobuf.decodeMessageField
              (HsProtobuf.FieldNumber 1)
          )
  dotProto _ =
    [ ( HsProtobuf.DotProtoField
          (HsProtobuf.FieldNumber 1)
          (HsProtobuf.Prim HsProtobuf.String)
          (HsProtobuf.Single "index")
          []
          ""
      )
    ]

instance HsJSONPB.ToJSONPB GetProjectsRequest where
  toJSONPB (GetProjectsRequest f1) =
    (HsJSONPB.object ["index" .= f1])
  toEncodingPB (GetProjectsRequest f1) =
    (HsJSONPB.pairs ["index" .= f1])

instance HsJSONPB.FromJSONPB GetProjectsRequest where
  parseJSONPB =
    ( HsJSONPB.withObject
        "GetProjectsRequest"
        (\obj -> (Hs.pure GetProjectsRequest) <*> obj .: "index")
    )

instance HsJSONPB.ToJSON GetProjectsRequest where
  toJSON = HsJSONPB.toAesonValue
  toEncoding = HsJSONPB.toAesonEncoding

instance HsJSONPB.FromJSON GetProjectsRequest where
  parseJSON = HsJSONPB.parseJSONPB

instance HsJSONPB.ToSchema GetProjectsRequest where
  declareNamedSchema _ =
    do
      let declare_index = HsJSONPB.declareSchemaRef
      getProjectsRequestIndex <- declare_index Proxy.Proxy
      let _ =
            Hs.pure GetProjectsRequest
              <*> HsJSONPB.asProxy declare_index
      Hs.return
        ( HsJSONPB.NamedSchema
            { HsJSONPB._namedSchemaName =
                Hs.Just "GetProjectsRequest",
              HsJSONPB._namedSchemaSchema =
                Hs.mempty
                  { HsJSONPB._schemaParamSchema =
                      Hs.mempty
                        { HsJSONPB._paramSchemaType =
                            Hs.Just HsJSONPB.SwaggerObject
                        },
                    HsJSONPB._schemaProperties =
                      HsJSONPB.insOrdFromList
                        [("index", getProjectsRequestIndex)]
                  }
            }
        )

newtype GetProjectsResponse = GetProjectsResponse
  { getProjectsResponseProjects ::
      Hs.Vector Monocle.Config.ProjectDefinition
  }
  deriving (Hs.Show, Hs.Eq, Hs.Ord, Hs.Generic, Hs.NFData)

instance HsProtobuf.Named GetProjectsResponse where
  nameOf _ = (Hs.fromString "GetProjectsResponse")

instance HsProtobuf.HasDefault GetProjectsResponse

instance HsProtobuf.Message GetProjectsResponse where
  encodeMessage
    _
    GetProjectsResponse
      { getProjectsResponseProjects =
          getProjectsResponseProjects
      } =
      ( Hs.mconcat
          [ ( HsProtobuf.encodeMessageField
                (HsProtobuf.FieldNumber 1)
                ( Hs.coerce @(Hs.Vector Monocle.Config.ProjectDefinition)
                    @(HsProtobuf.NestedVec Monocle.Config.ProjectDefinition)
                    getProjectsResponseProjects
                )
            )
          ]
      )
  decodeMessage _ =
    (Hs.pure GetProjectsResponse)
      <*> ( Hs.coerce
              @(_ (HsProtobuf.NestedVec Monocle.Config.ProjectDefinition))
              @(_ (Hs.Vector Monocle.Config.ProjectDefinition))
              ( HsProtobuf.at
                  HsProtobuf.decodeMessageField
                  (HsProtobuf.FieldNumber 1)
              )
          )
  dotProto _ =
    [ ( HsProtobuf.DotProtoField
          (HsProtobuf.FieldNumber 1)
          ( HsProtobuf.Repeated
              (HsProtobuf.Named (HsProtobuf.Single "ProjectDefinition"))
          )
          (HsProtobuf.Single "projects")
          []
          ""
      )
    ]

instance HsJSONPB.ToJSONPB GetProjectsResponse where
  toJSONPB (GetProjectsResponse f1) =
    (HsJSONPB.object ["projects" .= f1])
  toEncodingPB (GetProjectsResponse f1) =
    (HsJSONPB.pairs ["projects" .= f1])

instance HsJSONPB.FromJSONPB GetProjectsResponse where
  parseJSONPB =
    ( HsJSONPB.withObject
        "GetProjectsResponse"
        (\obj -> (Hs.pure GetProjectsResponse) <*> obj .: "projects")
    )

instance HsJSONPB.ToJSON GetProjectsResponse where
  toJSON = HsJSONPB.toAesonValue
  toEncoding = HsJSONPB.toAesonEncoding

instance HsJSONPB.FromJSON GetProjectsResponse where
  parseJSON = HsJSONPB.parseJSONPB

instance HsJSONPB.ToSchema GetProjectsResponse where
  declareNamedSchema _ =
    do
      let declare_projects = HsJSONPB.declareSchemaRef
      getProjectsResponseProjects <- declare_projects Proxy.Proxy
      let _ =
            Hs.pure GetProjectsResponse
              <*> HsJSONPB.asProxy declare_projects
      Hs.return
        ( HsJSONPB.NamedSchema
            { HsJSONPB._namedSchemaName =
                Hs.Just "GetProjectsResponse",
              HsJSONPB._namedSchemaSchema =
                Hs.mempty
                  { HsJSONPB._schemaParamSchema =
                      Hs.mempty
                        { HsJSONPB._paramSchemaType =
                            Hs.Just HsJSONPB.SwaggerObject
                        },
                    HsJSONPB._schemaProperties =
                      HsJSONPB.insOrdFromList
                        [ ( "projects",
                            getProjectsResponseProjects
                          )
                        ]
                  }
            }
        )

newtype HealthRequest = HealthRequest
  { healthRequestIndex ::
      Hs.Text
  }
  deriving (Hs.Show, Hs.Eq, Hs.Ord, Hs.Generic, Hs.NFData)

instance HsProtobuf.Named HealthRequest where
  nameOf _ = (Hs.fromString "HealthRequest")

instance HsProtobuf.HasDefault HealthRequest

instance HsProtobuf.Message HealthRequest where
  encodeMessage
    _
    HealthRequest {healthRequestIndex = healthRequestIndex} =
      ( Hs.mconcat
          [ ( HsProtobuf.encodeMessageField
                (HsProtobuf.FieldNumber 1)
                healthRequestIndex
            )
          ]
      )
  decodeMessage _ =
    (Hs.pure HealthRequest)
      <*> ( HsProtobuf.at
              HsProtobuf.decodeMessageField
              (HsProtobuf.FieldNumber 1)
          )
  dotProto _ =
    [ ( HsProtobuf.DotProtoField
          (HsProtobuf.FieldNumber 1)
          (HsProtobuf.Prim HsProtobuf.String)
          (HsProtobuf.Single "index")
          []
          ""
      )
    ]

instance HsJSONPB.ToJSONPB HealthRequest where
  toJSONPB (HealthRequest f1) = (HsJSONPB.object ["index" .= f1])
  toEncodingPB (HealthRequest f1) = (HsJSONPB.pairs ["index" .= f1])

instance HsJSONPB.FromJSONPB HealthRequest where
  parseJSONPB =
    ( HsJSONPB.withObject
        "HealthRequest"
        (\obj -> (Hs.pure HealthRequest) <*> obj .: "index")
    )

instance HsJSONPB.ToJSON HealthRequest where
  toJSON = HsJSONPB.toAesonValue
  toEncoding = HsJSONPB.toAesonEncoding

instance HsJSONPB.FromJSON HealthRequest where
  parseJSON = HsJSONPB.parseJSONPB

instance HsJSONPB.ToSchema HealthRequest where
  declareNamedSchema _ =
    do
      let declare_index = HsJSONPB.declareSchemaRef
      healthRequestIndex <- declare_index Proxy.Proxy
      let _ = Hs.pure HealthRequest <*> HsJSONPB.asProxy declare_index
      Hs.return
        ( HsJSONPB.NamedSchema
            { HsJSONPB._namedSchemaName =
                Hs.Just "HealthRequest",
              HsJSONPB._namedSchemaSchema =
                Hs.mempty
                  { HsJSONPB._schemaParamSchema =
                      Hs.mempty
                        { HsJSONPB._paramSchemaType =
                            Hs.Just HsJSONPB.SwaggerObject
                        },
                    HsJSONPB._schemaProperties =
                      HsJSONPB.insOrdFromList
                        [("index", healthRequestIndex)]
                  }
            }
        )

newtype HealthResponse = HealthResponse
  { healthResponseStatus ::
      Hs.Text
  }
  deriving (Hs.Show, Hs.Eq, Hs.Ord, Hs.Generic, Hs.NFData)

instance HsProtobuf.Named HealthResponse where
  nameOf _ = (Hs.fromString "HealthResponse")

instance HsProtobuf.HasDefault HealthResponse

instance HsProtobuf.Message HealthResponse where
  encodeMessage
    _
    HealthResponse {healthResponseStatus = healthResponseStatus} =
      ( Hs.mconcat
          [ ( HsProtobuf.encodeMessageField
                (HsProtobuf.FieldNumber 1)
                healthResponseStatus
            )
          ]
      )
  decodeMessage _ =
    (Hs.pure HealthResponse)
      <*> ( HsProtobuf.at
              HsProtobuf.decodeMessageField
              (HsProtobuf.FieldNumber 1)
          )
  dotProto _ =
    [ ( HsProtobuf.DotProtoField
          (HsProtobuf.FieldNumber 1)
          (HsProtobuf.Prim HsProtobuf.String)
          (HsProtobuf.Single "status")
          []
          ""
      )
    ]

instance HsJSONPB.ToJSONPB HealthResponse where
  toJSONPB (HealthResponse f1) = (HsJSONPB.object ["status" .= f1])
  toEncodingPB (HealthResponse f1) =
    (HsJSONPB.pairs ["status" .= f1])

instance HsJSONPB.FromJSONPB HealthResponse where
  parseJSONPB =
    ( HsJSONPB.withObject
        "HealthResponse"
        (\obj -> (Hs.pure HealthResponse) <*> obj .: "status")
    )

instance HsJSONPB.ToJSON HealthResponse where
  toJSON = HsJSONPB.toAesonValue
  toEncoding = HsJSONPB.toAesonEncoding

instance HsJSONPB.FromJSON HealthResponse where
  parseJSON = HsJSONPB.parseJSONPB

instance HsJSONPB.ToSchema HealthResponse where
  declareNamedSchema _ =
    do
      let declare_status = HsJSONPB.declareSchemaRef
      healthResponseStatus <- declare_status Proxy.Proxy
      let _ = Hs.pure HealthResponse <*> HsJSONPB.asProxy declare_status
      Hs.return
        ( HsJSONPB.NamedSchema
            { HsJSONPB._namedSchemaName =
                Hs.Just "HealthResponse",
              HsJSONPB._namedSchemaSchema =
                Hs.mempty
                  { HsJSONPB._schemaParamSchema =
                      Hs.mempty
                        { HsJSONPB._paramSchemaType =
                            Hs.Just HsJSONPB.SwaggerObject
                        },
                    HsJSONPB._schemaProperties =
                      HsJSONPB.insOrdFromList
                        [("status", healthResponseStatus)]
                  }
            }
        )
