From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: [PATCH v6 5/5] fw_cfg: document ACPI device node
	information
Date: Wed, 27 Jan 2016 22:02:41 -0500
Message-ID: <1453950161-13252-6-git-send-email-somlo@cmu.edu>
References: <1453950161-13252-1-git-send-email-somlo@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1453950161-13252-1-git-send-email-somlo@cmu.edu>
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

Signed-off-by: Gabriel Somlo <somlo@cmu.edu>
Reviewed-by: Laszlo Ersek <lersek@redhat.com>
Reviewed-by: Marc Mar=C3=AD <markmb@redhat.com>
---
 docs/specs/fw_cfg.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/docs/specs/fw_cfg.txt b/docs/specs/fw_cfg.txt
index 2099ad9..5414140 100644
--- a/docs/specs/fw_cfg.txt
+++ b/docs/specs/fw_cfg.txt
@@ -84,6 +84,15 @@ Selector Register address: Base + 8 (2 bytes)
 Data Register address:     Base + 0 (8 bytes)
 DMA Address address:       Base + 16 (8 bytes)
=20
+=3D=3D ACPI Interface =3D=3D
+
+The fw_cfg device is defined with ACPI ID "QEMU0002". Since we expect
+ACPI tables to be passed into the guest through the fw_cfg device itself=
,
+the guest-side firmware can not use ACPI to find fw_cfg. However, once t=
he
+firmware is finished setting up ACPI tables and hands control over to th=
e
+guest kernel, the latter can use the fw_cfg ACPI node for a more accurat=
e
+inventory of in-use IOport or MMIO regions.
+
 =3D=3D Firmware Configuration Items =3D=3D
=20
 =3D=3D=3D Signature (Key 0x0000, FW_CFG_SIGNATURE) =3D=3D=3D
--=20
2.4.3
