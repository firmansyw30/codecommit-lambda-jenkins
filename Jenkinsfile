// This pipeline is just an example. Adjust according to your project structure and requirements.
// For this case, this an example for deploying a React app to AWS S3 and invalidating CloudFront cache.

pipeline {
    agent any

    tools {
        // Replace 'nodejs-installation-name' with the name you set in Jenkins global tool configuration
        nodejs 'nodejs-installation-name'
    }

    environment {
        // Replace with the name of the target S3 bucket
        S3_BUCKET = 'your-s3-bucket-name'
        // Replace with the CloudFront distribution ID
        CLOUDFRONT_DISTRIBUTION_ID = 'your-cloudfront-distribution-id'
        // Jenkins credentials for Discord webhook
        DISCORD_WEBHOOK_URL = credentials('discord-webhook-credentials-id')
        // Jenkins credentials for AWS access
        AWS_CREDENTIALS = 'aws-credentials-id'
        AWS_REGION = 'ap-southeast-3' // or other region as needed
    }

    stages {
        stage('Install & Build') {
            steps {
                sh 'node -v'
                sh 'npm -v'
                sh 'npm ci --legacy-peer-deps'
                sh 'CI=false NODE_OPTIONS="--max-old-space-size=4096" npm run build'
                sh 'ls -la build'
            }
        }

        stage('Test (optional)') {
            when {
                expression { fileExists('package.json') }
            }
            steps {
                sh 'npm test || echo "⚠️ No tests configured or tests failed"'
            }
        }

        stage('Deploy to S3 & Invalidate CloudFront') {
            steps {
                withAWS(credentials: "${AWS_CREDENTIALS}", region: "${AWS_REGION}") {
                    echo 'Deploying to S3...'
                    sh 'aws s3 sync ./build s3://${S3_BUCKET} --delete'
                    echo 'Invalidating CloudFront cache...'
                    sh '''
                        aws cloudfront create-invalidation \
                            --distribution-id ${CLOUDFRONT_DISTRIBUTION_ID} \
                            --paths "/*"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline succeeded!'
            discordSend(
                webhookURL: "${env.DISCORD_WEBHOOK_URL}",
                title: "${env.JOB_NAME} #${env.BUILD_NUMBER} - SUCCESS",
                description: "🎉 Job succeeded.\nSee details: [${env.BUILD_URL}](${env.BUILD_URL})",
                footer: "Jenkins @ ${new Date()}",
                link: env.BUILD_URL,
                result: currentBuild.currentResult
            )
        }
        failure {
            echo '❌ Pipeline failed!'
            discordSend(
                webhookURL: "${env.DISCORD_WEBHOOK_URL}",
                title: "${env.JOB_NAME} #${env.BUILD_NUMBER} - FAILURE",
                description: "🚨 Job failed.\nSee details: [${env.BUILD_URL}](${env.BUILD_URL})",
                footer: "Jenkins @ ${new Date()}",
                link: env.BUILD_URL,
                result: currentBuild.currentResult
            )
        }
        aborted {
            echo '⚠️ Pipeline aborted!'
        }
        always {
            echo '🧹 Cleaning up build artifacts...'
            sh 'rm -rf ./build'
        }
    }
}
