From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH v3 1/4] Make anon_inodes unconditional
Date: Tue, 23 Apr 2019 09:13:31 +0200
Message-ID: <0dd5adcf-51e9-00a8-cc79-e9bd36b4125e@metux.net>
References: <20190419120904.27502-1-christian@brauner.io>
 <20190419120904.27502-2-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190419120904.27502-2-christian@brauner.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, oleg@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 19.04.19 14:09, Christian Brauner wrote:

Hi,

> From: David Howells <dhowells@redhat.com>
> 
> Make the anon_inodes facility unconditional so that it can be used by core
> VFS code and pidfd code.

I'm not convinced this is necessary. Instead the new features should
select ANON_INODES when enabled. And yes: these features should be
configurable.

Why ? Because embedded folks need to trim down the kernel and drop
everything that's not absolutely needed.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
