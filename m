From: Jeffrey Vander Stoep <jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] seccomp: add SECCOMP_RET_ACK for non-fatal SIGSYS
Date: Thu, 28 Jan 2016 19:03:57 -0800
Message-ID: <CABXk95CvE7O8ZL864AoVtKA7XqA_XaxA66Zz5ncpDWFSO7C19Q@mail.gmail.com>
References: <20160129010651.GA13228@www.outflux.net>
	<CALCETrVpa1zxVXOJoYKZ0zLCdH07dBKbw0Yo-BSJRH0eP_RBvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVpa1zxVXOJoYKZ0zLCdH07dBKbw0Yo-BSJRH0eP_RBvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks! This is just what I need.

What are the drawbacks to returning the sigsys before executing the
system call? Otherwise this loses the benefit of properly reporting
registers for argument inspection.

How about SECCOMP_RET_PERMISSIVE? Describes the application rather
than the implementation. Otherwise preference is for
SECCOMP_RET_ALLOW_SIGSYS.
