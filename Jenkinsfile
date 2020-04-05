#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_DEVELOPER_MODE = "ORG"// ORG or PACKAGE
    def PACKAGE_ALIAS = "mypack"
    //sfdx executable 
    def toolbelt = tool 'toolbelt'
    def pmd = tool 'pmd'

    stage('CLEAN WORKSPACE'){
        cleanWs()
        dir("${env.WORKSPACE}@tmp") {
            deleteDir()
        }
        dir("${env.WORKSPACE}@script") {
            deleteDir()
        }
        dir("${env.WORKSPACE}@script@tmp") {
            deleteDir()
        }
    }

    stage('First'){
        
        rc = sh returnStatus: true, script: "${pmd} -d /force-app/main/default/classes/ -f xml -language apex -R rulesets/apex/quickstart.xml -cache pmdcache -failOnViolation false -r /target/pmd.xml"
    }

    stage('GET RESULT'){
        def pmd = scanForIssues tool: pmdParser(pattern: '**/target/pmd.xml')
            publishIssues issues: [pmd]

        publishIssues id: 'analysis', name: 'All Issues', 
                issues: [pmd], 
                filters: [includePackage('io.jenkins.plugins.analysis.*')]
    }

}
   

