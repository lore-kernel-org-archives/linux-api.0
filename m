From: Vivien Chappelier <vivien.chappelier-L+G57L1VLRbR7s880joybQ@public.gmane.org>
Subject: Re: [patch 1/2][RFC] add socketat syscall
Date: Wed, 12 Nov 2008 11:33:54 +0100
Message-ID: <491AB112.1030806@thomson.net>
References: <20081031215602.655672481@fr.ibm.com>	<20081031215900.810348746@fr.ibm.com>	<517f3f820811060522i7b3518aen47907a34b38adee9@mail.gmail.com>	<cfd18e0f0811060746l77fbe6fel83402ba543fccb38@mail.gmail.com>
	<491318DC.4000300@fr.ibm.com> <49143263.1040604@fr.ibm.com>
	<49143594.8030109@fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <49143594.8030109-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Daniel Lezcano <dlezcano-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Cedric Le Goater <clg-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Subrata Modak <subrata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

   The socketat() option is fine but only solves half of the problem. I 
also need to be able to change the default namespace of a process to 
join an existing network namespace.

   My use case is the following (embedded router): I have two separate 
networks, one with internet access running standard applications and 
routing LAN traffic, one with access to the operator network only and 
running dedicated applications such as software upgrade or telephony 
software. These two networks have to be totally separate and I need the 
ability to run applications and open sockets in any of these networks or 
even both. With the current proposal, I could have init or some 
additional daemon create the two namespaces and ask it to fork and exec 
the applications I want to run so that it can give the open socket to 
its child. However this solution is not very practical nor elegant 
compared to the chvrf approach.

   The fs solution proposed by Eric to name, create, and remove network 
namespaces is fine. IMHO using the filesystem to create sockets would be 
a bad option as the filename would need to be parsed for every protocol 
etc.. So combining the filesystem idea with the socketat() syscall is a 
good way of solving both issues. In this case, each namespace would be 
represented with a single file and we could also give the fd obtained by 
opening this file as the socketat() argument. I also prefer extending 
socket() as was suggested previously rather than adding a new syscall, 
but this is up to the syscall API maintainers to decide.

regards,
Vivien.
