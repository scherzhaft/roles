# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

export CATALINA_BASE=/opt/tomcat7
export JAVA_HOME=/usr/java/latest
export PATH=${JAVA_HOME}/bin:${JAVA_HOME}:${CATALINA_BASE}/bin:${PATH}
export CLASSPATH=/opt/tomcat7/lib/commons-dbcp2/commons-dbcp2-2.0.1.jar:/opt/tomcat7/lib/ojdbc6.jar:/opt/tomcat7/lib/tomcat-jdbc.jar:${CLASSPATH}

