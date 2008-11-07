From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [patch 1/2][RFC] add socketat syscall
Date: Fri, 07 Nov 2008 08:09:54 -0800
Message-ID: <m1zlkbtt4d.fsf@frodo.ebiederm.org>
References: <20081031215602.655672481@fr.ibm.com>
	<20081031215900.810348746@fr.ibm.com>
	<517f3f820811060522i7b3518aen47907a34b38adee9@mail.gmail.com>
	<cfd18e0f0811060746l77fbe6fel83402ba543fccb38@mail.gmail.com>
	<491318DC.4000300@fr.ibm.com> <49143263.1040604@fr.ibm.com>
	<49143594.8030109@fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49143594.8030109-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org> (Daniel Lezcano's message of "Fri,
	07 Nov 2008 13:33:24 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Lezcano <dlezcano-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>
Cc: Cedric Le Goater <clg-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Subrata Modak <subrata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Vivien Chappelier <vivien.chappelier-L+G57L1VLRbR7s880joybQ@public.gmane.org>, Andreas B Aaen <andreas.aaen-546VmZ+UeKYX2WXlbB3fKg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Daniel Lezcano <dlezcano-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org> writes:

> AFAIU, the Eric's proposal in case a new syscall was not accepted. IMHO a new
> syscall, with the man pages is better than adding an extra obscure argument to a
> well known API.  But if there is a reason to not add a new syscall, we can
> consider Eric's approach as a good alternative I think.
>
> But before sending anything, I am still waiting for Vivien and Andreas answer
> about this approach. If it helps them to migrate their project to the network
> namespace, I will send something more formal.

In my queue I have some preliminary patches.  For both the syscall
thing and a filesystem that will pin the namespace.  I trying
to get my pile down so I can actually test it.

Ultimately to get the full functionality of the current linux-vrf
project we need:

socketat (or some variant thereof) so we can get unprivileged
creation of new sockets in another network namespace.

A fs to pin the network namespace and give it a name.

And ultimately a privileged operation sys_enter(int type, int fd);
To allow the default network namespace to be changed allowing
unprivileged applications to be run in the network namespace.

Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
