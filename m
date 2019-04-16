From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add
 CLONE_PIDFD]
Date: Tue, 16 Apr 2019 20:37:33 +0200
Message-ID: <8d1d47cf-3bf1-6c39-c02c-941515be1586@metux.net>
References: <20190414201436.19502-1-christian@brauner.io>
 <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190415195911.z7b7miwsj67ha54y@yavin>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <christian@brauner.io>, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 15.04.19 21:59, Aleksa Sarai wrote:

> Just spit-balling -- is no_new_privs not sufficient for this usecase?> Not granting privileges such as setuid during execve(2) is the main>
point of that flag.
Oh, I wasn't aware of that. Thanks.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
