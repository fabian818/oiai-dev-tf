variable "aws_region" {
  type        = string
  description = "AWS Region where infrastructure is deployed"
  default     = "us-east-1"
***REMOVED***

variable "additional_tags" {
  type        = map(string)
  description = "additional tags on resources"
***REMOVED***

variable "resource_prefix" {
  type        = string
  description = "Prefix for resources created in this module"
***REMOVED***

variable "component_prefix" {
  type        = string
  description = "Specific prefix for this component"
***REMOVED***

variable "force_delete" {
  type = bool
***REMOVED***