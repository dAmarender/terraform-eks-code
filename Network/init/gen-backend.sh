
d=`pwd`
cd init
section="net"
reg=`terraform output region`
if [[ -z ${reg} ]] ; then
echo "no terraform output variables - exiting ....."
echo "run terraform init/plan/apply in the the init directory first"
else
echo "region=$reg"
rm -f $of $of
fi


tabn=`terraform output dynamodb_table_name`
s3b=`terraform output s3_bucket`
echo $s3b $tabn


cd $d
of=`echo "backend-${section}.tf"`
printf "" > $of
printf "terraform {\n" >> $of
printf "required_version = \">= 0.12, < 0.13\"\n" >> $of
printf "backend \"s3\" {\n" >> $of
printf "bucket = \"%s\"\n"  $s3b >> $of
printf "key = \"terraform/%s.tfstate\"\n"  $tabn >> $of
printf "region = \"%s\"\n"  $reg >> $of
printf "dynamodb_table = \"%s\"\n"  $tabn >> $of
printf "encrypt = \"true\"\n"   >> $of
printf "}\n" >> $of
printf "}\n" >> $of
printf "\n" >> $of
printf "provider \"aws\" {\n" >> $of
printf "region = var.region\n"  >> $of
printf "shared_credentials_file = \"~/.aws/credentials\"\n" >> $of
printf "profile = var.profile\n" >> $of
printf "# Allow any 3.1x version of the AWS provider\n" >> $of
printf "version = \"~> 3.10\"\n" >> $of
printf "}\n" >> $of

of=`echo "remote-${section}.tf.sav"`
printf "" > $of
printf "data terraform_remote_state \"network\" {\n" >> $of
printf "backend = \"s3\"\n" >> $of
printf "config = {\n" >> $of
printf "bucket = \"%s\"\n"  $s3b >> $of
printf "region = \"%s\"\n"  $reg >> $of
printf "key = \"terraform/%s.tfstate\"\n"  $tabn >> $of
printf "}\n" >> $of
printf "}\n" >> $of


cp init/vars.tf .





