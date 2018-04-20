From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v3 04/17] y2038: s390: Remove unneeded ipc uapi header
 files
Date: Fri, 20 Apr 2018 09:54:07 +0200
Message-ID: <20180420075407.GA7119@osiris>
References: <20180419143737.606138-1-arnd@arndb.de>
 <20180419143737.606138-5-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419143737.606138-5-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, albert.aribaud@3adev.fr, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, x86@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-mips@linux-mips.org, jhogan@kernel.org, ralf@linux-mips.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2018 at 04:37:24PM +0200, Arnd Bergmann wrote:
> The s390 msgbuf/sembuf/shmbuf header files are all identical to the
> version from asm-generic.
> 
> This patch removes the files and replaces them with 'generic-y'
> statements, to avoid having to modify each copy when we extend sysvipc
> to deal with 64-bit time_t in 32-bit user space.
> 
> Note that unlike alpha and ia64, the ipcbuf.h header file is slightly
> different here, so I'm leaving the private copy.
> 
> To deal with 32-bit compat tasks, we also have to adapt the definitions
> of compat_{shm,sem,msg}id_ds to match the changes to the respective
> asm-generic files.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/s390/include/asm/compat.h      | 32 ++++++++++++------------
>  arch/s390/include/uapi/asm/Kbuild   |  3 +++
>  arch/s390/include/uapi/asm/msgbuf.h | 38 ----------------------------
>  arch/s390/include/uapi/asm/sembuf.h | 30 -----------------------
>  arch/s390/include/uapi/asm/shmbuf.h | 49 -------------------------------------
>  5 files changed, 19 insertions(+), 133 deletions(-)
>  delete mode 100644 arch/s390/include/uapi/asm/msgbuf.h
>  delete mode 100644 arch/s390/include/uapi/asm/sembuf.h
>  delete mode 100644 arch/s390/include/uapi/asm/shmbuf.h

FWIW,

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
