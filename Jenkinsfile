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

    stage('CHECKOUT SOURCE') {
        echo '------------------ INICIANDO O CHECKOUT SOURCE '
        checkout scm
        echo '------------------ FINALIZANDO O CHECKOUT SOURCE '
    }

    stage('RUN PMD'){
        sh "mkdir -p target"
        rc = sh returnStatus: true, script: "${pmd} pmd -d ./force-app/main/default/classes/ -f xml -language apex -R rulesets/apex/quickstart.xml -cache pmdcache -failOnViolation false -r ./target/pmd.xml"
    }

    stage('RUN CPD'){
        rc = sh returnStatus: true, script: "${pmd} cpd --files ./force-app/main/default/classes/ --format xml --language apex --minimum-tokens 100 > ./target/pmd.xml"
    }

    stage('GET RESULT'){
        def pmdResult = scanForIssues tool: pmdParser(pattern: '**/target/pmd.xml')
            publishIssues issues: [pmdResult]

        def cpd = scanForIssues tool: cpd(pattern: '**/target/cpd.xml')
            publishIssues issues: [cpd]

        publishIssues id: 'analysis', name: 'All Issues', 
                issues: [pmdResult, cpd], 
                filters: [includePackage('io.jenkins.plugins.analysis.*')]
    }

    stage('RUN '){

    }

}
   

