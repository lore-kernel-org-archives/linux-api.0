From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [patch 1/2][RFC] add socketat syscall
Date: Wed, 12 Nov 2008 07:24:45 -0800
Message-ID: <m1vdutotky.fsf@frodo.ebiederm.org>
References: <20081031215602.655672481@fr.ibm.com>
	<20081031215900.810348746@fr.ibm.com>
	<517f3f820811060522i7b3518aen47907a34b38adee9@mail.gmail.com>
	<cfd18e0f0811060746l77fbe6fel83402ba543fccb38@mail.gmail.com>
	<491318DC.4000300@fr.ibm.com> <49143263.1040604@fr.ibm.com>
	<49143594.8030109@fr.ibm.com> <491AB112.1030806@thomson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <491AB112.1030806-L+G57L1VLRbR7s880joybQ@public.gmane.org> (Vivien Chappelier's message of
	"Wed, 12 Nov 2008 11:33:54 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivien Chappelier <vivien.chappelier-L+G57L1VLRbR7s880joybQ@public.gmane.org>
Cc: Daniel Lezcano <dlezcano-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>, Cedric Le Goater <clg-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Subrata Modak <subrata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andreas B Aaen <andreas.aaen-546VmZ+UeKYX2WXlbB3fKg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Vivien Chappelier <vivien.chappelier-L+G57L1VLRbR7s880joybQ@public.gmane.org> writes:

> Hi,
>
>   The socketat() option is fine but only solves half of the problem. I also need
> to be able to change the default namespace of a process to join an existing
> network namespace.

I'm trying to get a feel.  What kind of applications do you have for which
you are changing the default network namespace aka chvrf?

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
