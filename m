From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v6 0/5] add ACPI node for fw_cfg on pc and arm
Date: Wed, 27 Jan 2016 22:00:52 -0500
Message-ID: <1453950057-13176-1-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, lersek@redhat.com, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, eric@anholt.net, hanjun.guo@linaro.org, zajec5@gmail.com, sudeep.holla@arm.com, agross@codeaurora.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: peter.maydell@linaro.org, ehabkost@redhat.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, stefanha@gmail.com, mst@redhat.com, qemu-devel@nongnu.org, leif.lindholm@linaro.org, luto@amacapital.net, kraxel@redhat.com, pbonzini@redhat.com, imammedo@redhat.com, revol@free.fr, rth@twiddle.net
List-Id: linux-api@vger.kernel.org

New since v5:

	- rebased on top of latest QEMU git master

Thanks,
  --Gabriel

>New since v4:
>
>	- rebased on top of Marc's DMA series
>	- drop machine compat dependency for insertion into x86/ssdt
>	  (patch 3/5), following agreement between Igor and Eduardo
>	- [mm]io register range now covers DMA register as well, if
>	  available.
>	- s/bios/firmware in doc file updates
>
>>New since v3:
>>
>>	- rebased to work on top of 87e896ab (introducing pc-*-25 classes),
>>	  inserting fw_cfg acpi node only for machines >=3D 2.5.
>>
>>	- reintroduce _STA with value 0x0B (bit 2 for u/i visibility turned
>>	  off to avoid Windows complaining -- thanks Igor for catching that!)
>>
>>If there's any other feedback besides questions regarding the
>>appropriateness of "QEMU0002" as the value of _HID, please don't hesita=
te!
>>
>>>New since v2:
>>>
>>>	- pc/i386 node in ssdt only on machine types *newer* than 2.4
>>>	  (as suggested by Eduardo)
>>>
>>>I appreciate any further comments and reviews. Hopefully we can make
>>>this palatable for upstream, modulo the lingering concerns about wheth=
er
>>>"QEMU0002" is ok to use as the value of _HID, which I'll hopefully get
>>>sorted out with the kernel crew...
>>>
>>>>New since v1:
>>>>
>>>>	- expose control register size (suggested by Marc Mar=C3=AD)
>>>>
>>>>	- leaving out _UID and _STA fields (thanks Shannon & Igor)
>>>>
>>>>	- using "QEMU0002" as the value of _HID (thanks Michael)
>>>>
>>>>	- added documentation blurb to docs/specs/fw_cfg.txt
>>>>	  (mainly to record usage of the "QEMU0002" string with fw_cfg).
>>>>
>>>>> This series adds a fw_cfg device node to the SSDT (on pc), or to th=
e
>>>>> DSDT (on arm).
>>>>>
>>>>> 	- Patch 1/3 moves (and renames) the BIOS_CFG_IOPORT (0x510)
>>>>> 	  define from pc.c to pc.h, so that it could be used from
>>>>> 	  acpi-build.c in patch 2/3.
>>>>>=20
>>>>> 	- Patch 2/3 adds a fw_cfg node to the pc SSDT.
>>>>>=20
>>>>> 	- Patch 3/3 adds a fw_cfg node to the arm DSDT.
>>>>>
>>>>> I made up some names - "FWCF" for the node name, and "FWCF0001"
>>>>> for _HID; no idea whether that's appropriate, or how else I should
>>>>> figure out what to use instead...
>>>>>
>>>>> Also, using scope "\\_SB", based on where fw_cfg shows up in the
>>>>> output of "info qtree". Again, if that's wrong, please point me in
>>>>> the right direction.
>>>>>
>>>>> Re. 3/3 (also mentioned after the commit blurb in the patch itself)=
,
>>>>> I noticed none of the other DSDT entries contain a _STA field, wond=
ering
>>>>> why it would (not) make sense to include that, same as on the PC.

Gabriel L. Somlo (5):
  fw_cfg: expose control register size in fw_cfg.h
  pc: fw_cfg: move ioport base constant to pc.h
  acpi: pc: add fw_cfg device node to ssdt
  acpi: arm: add fw_cfg device node to dsdt
  fw_cfg: document ACPI device node information

 docs/specs/fw_cfg.txt     |  9 +++++++++
 hw/arm/virt-acpi-build.c  | 15 +++++++++++++++
 hw/i386/acpi-build.c      | 29 +++++++++++++++++++++++++++++
 hw/i386/pc.c              |  5 ++---
 hw/nvram/fw_cfg.c         |  4 +++-
 include/hw/i386/pc.h      |  2 ++
 include/hw/nvram/fw_cfg.h |  3 +++
 7 files changed, 63 insertions(+), 4 deletions(-)

--=20
2.4.3
