From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/11] capsicum: implementations of new LSM hooks
Date: Wed, 2 Jul 2014 18:09:27 +0100
Message-ID: <CAHse=S_wZez=XOfGwkCCWXGMAFj3ivbL9g93RX66bOw3cYw1kQ@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-10-git-send-email-drysdale@google.com> <CALCETrUBCL1jKfooLaqrJCb-uYrMwYPQL2v-M04NTVf2LoD_fw@mail.gmail.com>
 <1871630.hB3tXi0r3a@sifl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1871630.hB3tXi0r3a@sifl>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 2, 2014 at 2:49 PM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
> On Monday, June 30, 2014 09:05:38 AM Andy Lutomirski wrote:
>> On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> > If the LSM does not provide implementations of the .file_lookup and
>> > .file_install LSM hooks, always use the Capsicum implementations.
>> >
>> > The Capsicum implementation of file_lookup checks for a Capsicum
>> > capability wrapper file and unwraps to if the appropriate rights
>> > are available.
>> >
>> > The Capsicum implementation of file_install checks whether the file
>> > has restricted rights associated with it.  If it does, it is replaced
>> > with a Capsicum capability wrapper file before installation into the
>> > fdtable.
>>
>> I think I fall on the "no LSM" side of the fence.  This kind of stuff
>> should be available regardless of selected LSM (as it is in your
>> code) ...
>
> I agree.  Looking quickly at the patches, the code seems to take an odd
> approach of living largely outside the LSM framework, but then relying on a
> couple of LSM hooks.  Capsicum should either live fully as a LSM or fully
> outside of it, this mix seems a bit silly to me.

Yeah, the end result was definitely a bit odd, hence the queries in the
cover email.  The consensus so far seems to be that they don't help,
so I'll remove the gratuitous LSM hooks on the next iteration.

Thanks,
David

> --
> paul moore
> www.paul-moore.com
>
