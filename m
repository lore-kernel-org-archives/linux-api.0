From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 10/23] y2038: uapi: change __kernel_time_t to
 __kernel_old_time_t
Date: Mon, 11 Nov 2019 13:38:32 +0100
Message-ID: <20191111123830.du25cahvat4ahg54@wittgenstein>
References: <20191108210236.1296047-1-arnd@arndb.de>
 <20191108211323.1806194-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191108211323.1806194-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 08, 2019 at 10:12:09PM +0100, Arnd Bergmann wrote:
> This is mainly a patch for clarification, and to let us remove
> the time_t definition from the kernel to prevent new users from
> creeping in that might not be y2038-safe.
> 
> All remaining uses of 'time_t' or '__kernel_time_t' are part of
> the user API that cannot be changed by that either have a
> replacement or that do not suffer from the y2038 overflow.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
