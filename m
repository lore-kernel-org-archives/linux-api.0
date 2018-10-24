From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] seccomp: Add pkru into seccomp_data
Date: Wed, 24 Oct 2018 20:06:59 +0200
Message-ID: <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
References: <20181024153523.10974-1-msammler@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20181024153523.10974-1-msammler@mpi-sws.org> (Michael Sammler's
 message of "Wed, 24 Oct 2018 17:35:23 +0200")
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Michael Sammler <msammler@mpi-sws.org>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>, Andy Lutomirski <luto@amacapital.net>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

* Michael Sammler:

> Add the current value of the PKRU register to data available for
> seccomp-bpf programs to work on. This allows filters based on the
> currently enabled protection keys.

> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 9efc0e73..e8b9ecfc 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -52,12 +52,16 @@
>   * @instruction_pointer: at the time of the system call.
>   * @args: up to 6 system call arguments always stored as 64-bit values
>   *        regardless of the architecture.
> + * @pkru: value of the pkru register
> + * @reserved: pad the structure to a multiple of eight bytes
>   */
>  struct seccomp_data {
>  	int nr;
>  	__u32 arch;
>  	__u64 instruction_pointer;
>  	__u64 args[6];
> +	__u32 pkru;
> +	__u32 reserved;
>  };

This doesn't cover the POWER implementation.  Adding Cc:s.

And I think the kernel shouldn't expose the number of protection keys in
the ABI.

Thanks,
Florian
