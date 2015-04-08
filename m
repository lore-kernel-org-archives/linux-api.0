From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 2/4] usb: gadget: mass_storage: Store lun_opts in
 fsg_opts
Date: Wed, 08 Apr 2015 16:56:52 +0200
Message-ID: <552541B4.4040905@samsung.com>
References: <Pine.LNX.4.44L0.1504081012240.1384-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <Pine.LNX.4.44L0.1504081012240.1384-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: balbi-l0cyMroinI0@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On 04/08/2015 04:15 PM, Alan Stern wrote:> On Wed, 8 Apr 2015, Krzysztof 
Opasiak wrote:
 >
 >> Signed-off-by: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
 >> ---
 >>   drivers/usb/gadget/function/f_mass_storage.c |    5 +++++
 >>   drivers/usb/gadget/function/f_mass_storage.h |    1 +
 >>   2 files changed, 6 insertions(+)
 >>
 >> diff --git a/drivers/usb/gadget/function/f_mass_storage.c 
b/drivers/usb/gadget/function/f_mass_storage.c
 >> index 811929c..095b618 100644
 >> --- a/drivers/usb/gadget/function/f_mass_storage.c
 >> +++ b/drivers/usb/gadget/function/f_mass_storage.c
 >> @@ -3372,6 +3372,8 @@ static struct config_group 
*fsg_lun_make(struct config_group *group,
 >>   	}
 >>   	opts->lun = fsg_opts->common->luns[num];
 >>   	opts->lun_id = num;
 >> +	BUG_ON(fsg_opts->lun_opts[num]);
 >
 > This is not a good idea.  BUG_ON should hardly ever be used.  In fact,
 > Linus has said that the only time BUG_ON should be used is when things
 > are so badly messed up that it is better to crash the computer than to
 > let it continue.
 >
 > What's wrong with using WARN_ON instead?

Nothing. I have simply used BUG_ON() because this situation should never 
happen. If it happed then we made some mess in luns and there is no easy 
way to recovery from this point. This is only a little defense point for 
future to make debugging easier. I may change this to WARN_ON() if you like.


 >
 >> diff --git a/drivers/usb/gadget/function/f_mass_storage.h 
b/drivers/usb/gadget/function/f_mass_storage.h
 >> index b4866fc..0a7c656 100644
 >> --- a/drivers/usb/gadget/function/f_mass_storage.h
 >> +++ b/drivers/usb/gadget/function/f_mass_storage.h
 >> @@ -81,6 +81,7 @@ struct fsg_opts {
 >>   	struct fsg_common *common;
 >>   	struct usb_function_instance func_inst;
 >>   	struct fsg_lun_opts lun0;
 >> +	struct fsg_lun_opts *lun_opts[FSG_MAX_LUNS];
 >
 > This looks strange.  Why is the entry for LUN 0 duplicated?

LUN 0 is created on mkdir and cannot be removed by user so the memory 
for it is allocated together with fsg_opts structure. Rest of LUNs are 
being created by explicit user action and malloc() separately. This 
array is used to store their pointers. To make the code easier we simply:

lun_opts[0] = &fsg_opts->lun0;

so later we don't care which lun we are dealing with.

--
Best regards,
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
