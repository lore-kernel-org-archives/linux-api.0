From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/1] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Fri, 30 Nov 2018 12:22:33 +0100
Message-ID: <20181130112233.GC23670@redhat.com>
References: <20181127225408.7553-2-j@bitron.ch>
 <20181130080004.23635-1-j@bitron.ch>
 <20181130080004.23635-2-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181130080004.23635-2-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/30, Jürg Billeter wrote:
>
> This introduces a new thread group flag that can be set by calling
>
>     prctl(PR_SET_KILL_DESCENDANTS_ON_EXIT, 1, 0, 0, 0)
>
> When a thread group exits with this flag set, it will send SIGKILL to
> all descendant processes.  This can be used to prevent stray child
> processes.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
