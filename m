From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [v8, bpf-next, 4/9] net/wireless/iwlwifi: fix iwlwifi_dev_ucode_error tracepoint
Date: Fri, 25 May 2018 13:48:02 +0300
Message-ID: <87zi0oko4d.fsf@purkki.adurom.net>
References: <20180328190540.370956-5-ast@kernel.org>
        <1527073388.3759.21.camel@sipsolutions.net>
        <20180524232837.24jvdsdiohkpj7fs@ast-mbp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180524232837.24jvdsdiohkpj7fs@ast-mbp> (Alexei Starovoitov's
        message of "Thu, 24 May 2018 16:28:39 -0700")
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, linux-wireless@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, May 23, 2018 at 01:03:08PM +0200, Johannes Berg wrote:
>> On Wed, 2018-03-28 at 12:05 -0700, Alexei Starovoitov wrote:
>> > fix iwlwifi_dev_ucode_error tracepoint to pass pointer to a table
>> > instead of all 17 arguments by value.
>> > dvm/main.c and mvm/utils.c have 'struct iwl_error_event_table'
>> > defined with very similar yet subtly different fields and offsets.
>> > tracepoint is still common and using definition of 'struct iwl_error_event_table'
>> > from dvm/commands.h while copying fields.
>> > Long term this tracepoint probably should be split into two.
>> 
>> It would've been nice to CC the wireless list for wireless related
>> patches ...
>
> Ohh. I didn't realize that networking wireless doesn't fall under netdev.
> I thought wireless folks are silent because they are embarrassed
> by a function with 17 arguments.

Really, this is the level of discussion now? You don't even bother to CC
the driver maintainers and your first reaction is that they are just too
embarrassed to answer? Oh man...

But if you continue doing these kind of "drive-by cleanups" to a
subsystem you are not familiar with, at least don't assume anything and
instead use get_maintainer script to find the maintainers so that the
patches get reviewed and applied to the correct tree:

$ scripts/get_maintainer.pl --no-rolestats --no-git -f drivers/net/wireless/intel/iwlwifi/dvm/main.c
Johannes Berg <johannes.berg@intel.com>
Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Luca Coelho <luciano.coelho@intel.com>
Intel Linux Wireless <linuxwifi@intel.com>
Kalle Valo <kvalo@codeaurora.org>
"David S. Miller" <davem@davemloft.net>
Daniel Borkmann <daniel@iogearbox.net>
Alexei Starovoitov <ast@kernel.org>
Kees Cook <keescook@chromium.org>
linux-wireless@vger.kernel.org
netdev@vger.kernel.org
linux-kernel@vger.kernel.org

-- 
Kalle Valo
