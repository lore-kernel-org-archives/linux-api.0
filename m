From: Dennis Clarke <dclarke@blastwave.org>
Subject: Re: [PATCH v2 00/29] y2038: add time64 syscalls
Date: Fri, 18 Jan 2019 12:19:56 -0500
Message-ID: <37173869-7516-55c5-8e4a-0c7bef011a62@blastwave.org>
References: <20190118161835.2259170-1-arnd@arndb.de>
 <be3863ae-d903-8e9e-5e6c-e4a58fac189d@blastwave.org>
 <CAK8P3a3xUpbk+Wpo5kdDtZ81jQuzEZH6jdmJJNeNM+acueg+Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAK8P3a3xUpbk+Wpo5kdDtZ81jQuzEZH6jdmJJNeNM+acueg+Dw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mips@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>, Networking <netdev@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Catalin Marinas <catalin.marinas@arm.com>, Firoz Khan <firoz.khan@linaro.org>, Matt Turner <mattst88@gmai>
List-Id: linux-api@vger.kernel.org

On 1/18/19 12:14 PM, Arnd Bergmann wrote:
> On Fri, Jan 18, 2019 at 5:57 PM Dennis Clarke <dclarke@blastwave.org> wrote:
>>
>> On 1/18/19 11:18 AM, Arnd Bergmann wrote:
>>> This is a minor update of the patches I posted last week, I
>>> would like to add this into linux-next now, but would still do
>>> changes if there are concerns about the contents. The first
>>> version did not see a lot of replies, which could mean that
>>> either everyone is happy with it, or that it was largely ignored.
>>>
>>> See also the article at https://lwn.net/Articles/776435/.
>>
>> I would be happy to read "Approaching the kernel year-2038 end game"
>> however it is behind a pay wall.  Perhaps it may be best to just
>> host interesting articles about open source idea elsewhere.
> 
> It's a short summary of the current state.

Oh, I pay. Also to FSF and other places however I was merely ranting
very very quietly that so much open source is becoming commercialized
in so many ways.  Sort of expected really.

Pardon my little rant .. I will go back to hacking OpenSSL 1.1.1a and
trying to get Apache httpd 2.4.38 release running cleanly.

Dennis
