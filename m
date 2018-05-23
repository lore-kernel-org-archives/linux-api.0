From: Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Subject: Re: [v8, bpf-next, 4/9] net/wireless/iwlwifi: fix
 iwlwifi_dev_ucode_error tracepoint
Date: Wed, 23 May 2018 13:03:08 +0200
Message-ID: <1527073388.3759.21.camel@sipsolutions.net>
References: <20180328190540.370956-5-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180328190540.370956-5-ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2018-03-28 at 12:05 -0700, Alexei Starovoitov wrote:
> fix iwlwifi_dev_ucode_error tracepoint to pass pointer to a table
> instead of all 17 arguments by value.
> dvm/main.c and mvm/utils.c have 'struct iwl_error_event_table'
> defined with very similar yet subtly different fields and offsets.
> tracepoint is still common and using definition of 'struct iwl_error_event_table'
> from dvm/commands.h while copying fields.
> Long term this tracepoint probably should be split into two.

It would've been nice to CC the wireless list for wireless related
patches ...

> --- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
> @@ -30,6 +30,7 @@
>  #ifndef __CHECKER__
>  #include "iwl-trans.h"
>  
> +#include "dvm/commands.h"

In particular, this breaks the whole driver abstraction.

> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
> @@ -549,12 +549,7 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
>  
>         IWL_ERR(mvm, "Loaded firmware version: %s\n", mvm->fw->fw_version);
>  
> -       trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
> -                                     table.data1, table.data2, table.data3,
> -                                     table.blink2, table.ilink1,
> -                                     table.ilink2, table.bcon_time, table.gp1,
> -                                     table.gp2, table.fw_rev_type, table.major,
> -                                     table.minor, table.hw_ver, table.brd_ver);
> +       trace_iwlwifi_dev_ucode_error(trans->dev, &table, table.hw_ver, table.brd_ver);

This is also utterly wrong because mvm has - for better or worse - a
different type "struct iwl_error_event_table" in this file ...

This really should never have gotten into the tree.

johannes
