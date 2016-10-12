From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: Re: [PATCH v3 08/11] powerpc/tracing: fix compat syscall handling
Date: Wed, 12 Oct 2016 15:10:34 +0200
Message-ID: <f21ef656-6835-5539-c875-931614850555@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1476182576-15247-9-git-send-email-marcin.nowakowski@imgtec.com>
 <87zim951m9.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87zim951m9.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org



On 12.10.2016 11:59, Michael Ellerman wrote:
> I went to test this and noticed the exit and enter events appear to be
> reversed in time? (your series on top of 24532f768121)

thanks for testing the patch - I've found a bug that has sneaked in 
while cleaning up the patches before submission ... I'll fix it in the 
next iteration.

Marcin
