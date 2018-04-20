From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 04/17] y2038: s390: Remove unneeded ipc uapi header files
Date: Fri, 20 Apr 2018 09:58:24 +0200
Message-ID: <CAK8P3a1_TLs=QZuMVbbAGMEct+SBg2wZ663Kq2RJN5mgU1ZCtw@mail.gmail.com>
References: <20180419143737.606138-1-arnd@arndb.de> <20180419143737.606138-5-arnd@arndb.de>
 <20180420075407.GA7119@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420075407.GA7119@osiris>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W . Biederman" <ebiederm@xmission.com>, Albert ARIBAUD <albert.aribaud@3adev.fr>, linux-s390 <linux-s390@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, the arch/x86 maintainers <x86@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, James Hogan <jhogan@kernel.org>, Ralf Baechle <ralf@linux>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 20, 2018 at 9:54 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Thu, Apr 19, 2018 at 04:37:24PM +0200, Arnd Bergmann wrote:
>> The s390 msgbuf/sembuf/shmbuf header files are all identical to the
>> version from asm-generic.
>>
>> This patch removes the files and replaces them with 'generic-y'
>> statements, to avoid having to modify each copy when we extend sysvipc
>> to deal with 64-bit time_t in 32-bit user space.
>>
>> Note that unlike alpha and ia64, the ipcbuf.h header file is slightly
>> different here, so I'm leaving the private copy.
>>
>> To deal with 32-bit compat tasks, we also have to adapt the definitions
>> of compat_{shm,sem,msg}id_ds to match the changes to the respective
>> asm-generic files.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  arch/s390/include/asm/compat.h      | 32 ++++++++++++------------
>>  arch/s390/include/uapi/asm/Kbuild   |  3 +++
>>  arch/s390/include/uapi/asm/msgbuf.h | 38 ----------------------------
>>  arch/s390/include/uapi/asm/sembuf.h | 30 -----------------------
>>  arch/s390/include/uapi/asm/shmbuf.h | 49 -------------------------------------
>>  5 files changed, 19 insertions(+), 133 deletions(-)
>>  delete mode 100644 arch/s390/include/uapi/asm/msgbuf.h
>>  delete mode 100644 arch/s390/include/uapi/asm/sembuf.h
>>  delete mode 100644 arch/s390/include/uapi/asm/shmbuf.h
>
> FWIW,
>
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Thanks, added to the patch.

     Arnd
