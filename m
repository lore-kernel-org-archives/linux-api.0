From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH 09/11] capsicum: implementations of new LSM hooks
Date: Wed, 02 Jul 2014 09:49:24 -0400
Message-ID: <1871630.hB3tXi0r3a@sifl>
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <1404124096-21445-10-git-send-email-drysdale@google.com> <CALCETrUBCL1jKfooLaqrJCb-uYrMwYPQL2v-M04NTVf2LoD_fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUBCL1jKfooLaqrJCb-uYrMwYPQL2v-M04NTVf2LoD_fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday, June 30, 2014 09:05:38 AM Andy Lutomirski wrote:
> On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > If the LSM does not provide implementations of the .file_lookup and
> > .file_install LSM hooks, always use the Capsicum implementations.
> > 
> > The Capsicum implementation of file_lookup checks for a Capsicum
> > capability wrapper file and unwraps to if the appropriate rights
> > are available.
> > 
> > The Capsicum implementation of file_install checks whether the file
> > has restricted rights associated with it.  If it does, it is replaced
> > with a Capsicum capability wrapper file before installation into the
> > fdtable.
> 
> I think I fall on the "no LSM" side of the fence.  This kind of stuff
> should be available regardless of selected LSM (as it is in your
> code) ...

I agree.  Looking quickly at the patches, the code seems to take an odd 
approach of living largely outside the LSM framework, but then relying on a 
couple of LSM hooks.  Capsicum should either live fully as a LSM or fully 
outside of it, this mix seems a bit silly to me.

-- 
paul moore
www.paul-moore.com
