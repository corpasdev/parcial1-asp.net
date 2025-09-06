<%@ Page Title="Sistema de Pedidos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Parcial_1._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfPasoActivo" runat="server" />
    <link href="Content/Default.css" rel="stylesheet" />
    <link href="Content/Default-styles.css" rel="stylesheet" type="text/css" />

    <main>
        <div class="row" style="margin-top: 100px;">
            <div class="col-md-12">
                <h1>Sistema de Pedidos en Línea</h1>
                <p class="lead">Complete el formulario para realizar su pedido</p>
            </div>
        </div>

        <!-- Indicador de Progreso -->
        <div class="progress-indicator mb-4">
            <div class="step" id="step1" data-step="1">
                <div class="step-circle">1</div>
                <div class="step-label">Datos del Cliente</div>
            </div>
            <div class="step" id="step2" data-step="2">
                <div class="step-circle">2</div>
                <div class="step-label">Productos</div>
            </div>
            <div class="step" id="step3" data-step="3">
                <div class="step-circle">3</div>
                <div class="step-label">Resumen</div>
            </div>
            <div class="step" id="step4" data-step="4">
                <div class="step-circle">4</div>
                <div class="step-label">Pago</div>
            </div>
            <div class="step" id="step5" data-step="5">
                <div class="step-circle">5</div>
                <div class="step-label">Confirmación</div>
            </div>
        </div>

        <div class="accordion" id="acordeonPedido">
            <!-- Paso 1: Cliente ingresa datos -->
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingDatosCliente">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDatosCliente" aria-expanded="true" aria-controls="collapseDatosCliente">
                        1. Datos del Cliente
                    </button>
                </h2>
                <div id="collapseDatosCliente" class="accordion-collapse collapse show" aria-labelledby="headingDatosCliente" data-bs-parent="#acordeonPedido">
                    <div class="accordion-body form-section">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="<%= txtCedula.ClientID %>">Cédula/NIT:</label>
                                    <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" placeholder="Ingrese su número de identificación"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCedula" runat="server" ControlToValidate="txtCedula"
                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="La cédula es obligatoria"
                                        ValidationGroup="DatosCliente"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revCedula" runat="server" ControlToValidate="txtCedula"
                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="Ingrese solo valores numéricos"
                                        ValidationGroup="DatosCliente" ValidationExpression="^[0-9]+$"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="<%= txtNombres.ClientID %>">Nombres completos:</label>
                                    <asp:TextBox ID="txtNombres" runat="server" CssClass="form-control" placeholder="Ingrese sus nombres completos"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombres" runat="server" ControlToValidate="txtNombres"
                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="El nombre es obligatorio"
                                        ValidationGroup="DatosCliente"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="<%= txtTelefono.ClientID %>">Teléfono:</label>
                                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="Ingrese su número de teléfono"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono"
                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="El teléfono es obligatorio"
                                        ValidationGroup="DatosCliente"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="<%= txtEmail.ClientID %>">Correo Electrónico:</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Ingrese su correo electrónico" TextMode="Email"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="El correo electrónico es obligatorio"
                                        ValidationGroup="DatosCliente"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="Ingrese un correo electrónico válido"
                                        ValidationGroup="DatosCliente" ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="<%= txtDireccionEnvio.ClientID %>">Dirección de envío:</label>
                                    <asp:TextBox ID="txtDireccionEnvio" runat="server" CssClass="form-control" placeholder="Ingrese la dirección de envío"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ControlToValidate="txtDireccionEnvio"
                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="La dirección es obligatoria"
                                        ValidationGroup="DatosCliente"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-12">
                                <asp:Button ID="btnContinuarProductos" runat="server" Text="Continuar a Selección de Productos"
                                    CssClass="btn btn-primary" OnClick="btnContinuarProductos_Click" ValidationGroup="DatosCliente" />
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Paso 2: Selecciona productos -->
                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingProductos">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseProductos" aria-expanded="false" aria-controls="collapseProductos">
                            2. Selección de Productos
                        </button>
                    </h2>
                    <div id="collapseProductos" class="accordion-collapse collapse" aria-labelledby="headingProductos" data-bs-parent="#acordeonPedido">
                        <div class="accordion-body form-section" id="seccionProductos" runat="server" visible="false">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="<%= ddlProducto.ClientID %>">Producto:</label>
                                        <asp:DropDownList ID="ddlProducto" runat="server" CssClass="form-control" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddlProducto_SelectedIndexChanged">
                                            <asp:ListItem Text="-- Seleccione un producto --" Value="|" />
                                            <asp:ListItem Text="Laptop HP" Value="1200|Laptop con procesador Intel Core i5, 8GB RAM, 256GB SSD" />
                                            <asp:ListItem Text="Smartphone Samsung" Value="800|Smartphone con pantalla AMOLED, 128GB almacenamiento, cámara 48MP" />
                                            <asp:ListItem Text="Tablet Apple" Value="600|Tablet con pantalla Retina, chip A14 Bionic, 64GB almacenamiento" />
                                            <asp:ListItem Text="Monitor LG" Value="300|Monitor LED de 27 pulgadas, resolución Full HD, panel IPS" />
                                            <asp:ListItem Text="Teclado Mecánico" Value="100|Teclado mecánico con switches Cherry MX, retroiluminación RGB" />
                                            <asp:ListItem Text="Ordenador de escritorio Dell OptiPlex 7000" Value="1299.99|Intel i7, 16GB RAM, 512GB SSD, Windows 11 Pro" />
                                            <asp:ListItem Text="Portátil HP ProBook 450 G9" Value="999.99|Intel i5, 8GB RAM, 512GB SSD, Windows 11 Home" />
                                            <asp:ListItem Text="Impresora multifuncional Epson EcoTank L3250" Value="299.99|Wi-Fi, impresión a color, escáner, sistema de tanque de tinta" />
                                            <asp:ListItem Text="Disco duro externo Seagate Expansion 2TB" Value="79.99|USB 3.0, compatible con PC y Mac, diseño compacto" />
                                            <asp:ListItem Text="SSD Samsung 970 EVO Plus 1TB" Value="149.99|NVMe, velocidad de lectura hasta 3500MB/s, factor de forma M.2" />
                                            <asp:ListItem Text="Cámara de seguridad IP Hikvision DS-2CD1043G0-I" Value="89.99|4MP, IR 30m, PoE, visión nocturna, IP67" />
                                            <asp:ListItem Text="DVR Hikvision Turbo HD 8 canales" Value="199.99|DS-7208HQHI-K1, H.265+, HDMI, VGA, soporte P2P" />
                                            <asp:ListItem Text="NVR Dahua NVR4108HS-8P-4KS2" Value="249.99|8 canales, PoE, 4K, H.265, HDMI, VGA" />
                                            <asp:ListItem Text="Kit de videovigilancia Ezviz 4 cámaras" Value="399.99|Full HD + DVR de 4 canales, visión nocturna, IP66" />
                                            <asp:ListItem Text="Monitor LED Samsung 24&quot; Full HD" Value="179.99|LS24R350FZL, 75Hz, FreeSync, panel IPS, HDMI" />
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvProducto" runat="server" ControlToValidate="ddlProducto"
                                            CssClass="validation-error" Display="Dynamic" ErrorMessage="Debe seleccionar un producto"
                                            ValidationGroup="Productos" InitialValue="|"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="<%= txtCantidad.ClientID %>">Cantidad:</label>
                                        <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" TextMode="Number" Text="1"></asp:TextBox>
                                        <asp:RangeValidator ID="rvCantidad" runat="server" ControlToValidate="txtCantidad"
                                            CssClass="validation-error" Display="Dynamic" ErrorMessage="La cantidad debe estar entre 1 y 100"
                                            MinimumValue="1" MaximumValue="100" Type="Integer" ValidationGroup="Productos"></asp:RangeValidator>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Precio Unitario:</label>
                                        <asp:Label ID="lblPrecioUnitario" runat="server" CssClass="form-control" Text="$0.00"></asp:Label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Descripción:</label>
                                        <asp:Label ID="lblDescripcion" runat="server" CssClass="form-control" Text=""></asp:Label>
                                    </div>
                                </div>
                            </div>
                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <asp:Button ID="btnAgregarProducto" runat="server" Text="Agregar al Carrito"
                                        CssClass="btn btn-primary" OnClick="btnAgregarProducto_Click" ValidationGroup="Productos" 
                                        Enabled="false" />
                                </div>
                            </div>

                            <div class="row mt-4">
                                <div class="col-md-12">
                                    <h3>Productos Seleccionados</h3>
                                    <asp:GridView ID="gvProductos" runat="server" AutoGenerateColumns="false" CssClass="table table-striped"
                                        OnRowCommand="gvProductos_RowCommand" EmptyDataText="No hay productos seleccionados">
                                        <Columns>
                                            <asp:BoundField DataField="Producto" HeaderText="Producto" />
                                            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                                            <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" />
                                            <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio Unitario" DataFormatString="${0:N2}" />
                                            <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="${0:N2}" />
                                            <asp:TemplateField HeaderText="Acciones">
                                                <ItemTemplate>
                                                    <asp:Button ID="btnEliminar" runat="server" CommandName="Eliminar"
                                                        CommandArgument="<%# Container.DataItemIndex %>" Text="Eliminar"
                                                        CssClass="btn btn-danger btn-sm" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>

                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <asp:Button ID="btnCalcularTotal" runat="server" Text="Calcular Total"
                                        CssClass="btn btn-primary" OnClick="btnCalcularTotal_Click" Enabled="false" />
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- Paso 3: Se calculan totales -->
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingTotales">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTotales" aria-expanded="false" aria-controls="collapseTotales">
                                3. Resumen del Pedido
                            </button>
                        </h2>
                        <div id="collapseTotales" class="accordion-collapse collapse" aria-labelledby="headingTotales" data-bs-parent="#acordeonPedido">
                            <div class="accordion-body form-section" id="seccionTotales" runat="server" visible="false">
                                <div class="row mt-4">
                                    <div class="col-md-12">
                                                            <h3>Productos Seleccionados</h3>
                                        <asp:GridView ID="gvResumenProductos" runat="server" AutoGenerateColumns="false" CssClass="table table-striped"
                                            EmptyDataText="No hay productos seleccionados">
                                            <Columns>
                                                <asp:BoundField DataField="Producto" HeaderText="Producto" />
                                                <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                                                <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" />
                                                <asp:BoundField DataField="PrecioUnitario" HeaderText="Precio Unitario" DataFormatString="${0:N2}" />
                                                <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="${0:N2}" />
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="summary-item">
                                            <span>Subtotal:</span>
                                            <asp:Label ID="lblSubtotal" runat="server" Text="$0.00"></asp:Label>
                                        </div>
                                        <div class="summary-item">
                                            <span>IVA (12%):</span>
                                            <asp:Label ID="lblImpuestos" runat="server" Text="$0.00"></asp:Label>
                                        </div>
                                        <div class="summary-item total-section">
                                            <span>Total a Pagar:</span>
                                            <asp:Label ID="lblTotal" runat="server" Text="$0.00"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <asp:CheckBox ID="chkConfirmar" runat="server" Text="Confirmo los datos y el pedido" />
                                            <asp:CustomValidator ID="cvConfirmar" runat="server" ErrorMessage="Debe confirmar el pedido"
                                                CssClass="validation-error" Display="Dynamic" ValidationGroup="Confirmar"
                                                OnServerValidate="cvConfirmar_ServerValidate"></asp:CustomValidator>
                                        </div>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-12">
                                        <asp:Button ID="btnConfirmarPedido" runat="server" Text="Confirmar Pedido"
                                            CssClass="btn btn-primary" OnClick="btnConfirmarPedido_Click" ValidationGroup="Confirmar" />
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- Paso 4: Elige método de pago -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingPago">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePago" aria-expanded="false" aria-controls="collapsePago">
                                    4. Método de Pago
                                </button>
                            </h2>
                            <div id="collapsePago" class="accordion-collapse collapse" aria-labelledby="headingPago" data-bs-parent="#acordeonPedido">
                                <div class="accordion-body form-section" id="seccionPago" runat="server" visible="false">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Seleccione su método de pago:</label>
                                                <asp:RadioButtonList ID="rblMetodoPago" runat="server" CssClass="payment-method" AutoPostBack="true" OnSelectedIndexChanged="rblMetodoPago_SelectedIndexChanged">
                                                    <asp:ListItem Text="Efectivo" Value="Efectivo" Selected="True" />
                                                    <asp:ListItem Text="Tarjeta Débito" Value="Debito" />
                                                    <asp:ListItem Text="Tarjeta Crédito" Value="Credito" />
                                                    <asp:ListItem Text="PayPal" Value="PayPal" />
                                                </asp:RadioButtonList>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Panel para datos de tarjeta -->
                                    <asp:Panel ID="pnlDatosTarjeta" runat="server" Visible="false" CssClass="mt-4">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <h4>Datos de la Tarjeta</h4>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="<%= txtNombreTarjeta.ClientID %>">Nombre en la tarjeta:</label>
                                                    <asp:TextBox ID="txtNombreTarjeta" runat="server" CssClass="form-control" placeholder="Nombre como aparece en la tarjeta"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvNombreTarjeta" runat="server" ControlToValidate="txtNombreTarjeta"
                                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="El nombre en la tarjeta es obligatorio"
                                                        ValidationGroup="DatosTarjeta"></asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="<%= txtNumeroTarjeta.ClientID %>">Número de tarjeta:</label>
                                                    <asp:TextBox ID="txtNumeroTarjeta" runat="server" CssClass="form-control" placeholder="XXXX XXXX XXXX XXXX" MaxLength="19"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvNumeroTarjeta" runat="server" ControlToValidate="txtNumeroTarjeta"
                                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="El número de tarjeta es obligatorio"
                                                        ValidationGroup="DatosTarjeta"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="revNumeroTarjeta" runat="server" ControlToValidate="txtNumeroTarjeta"
                                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="Ingrese un número de tarjeta válido"
                                                        ValidationGroup="DatosTarjeta" ValidationExpression="^[0-9 ]{13,19}$"></asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row mt-3">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label for="<%= txtMesVencimiento.ClientID %>">Mes de vencimiento:</label>
                                                    <asp:DropDownList ID="txtMesVencimiento" runat="server" CssClass="form-control">
                                                        <asp:ListItem Text="01" Value="01" />
                                                        <asp:ListItem Text="02" Value="02" />
                                                        <asp:ListItem Text="03" Value="03" />
                                                        <asp:ListItem Text="04" Value="04" />
                                                        <asp:ListItem Text="05" Value="05" />
                                                        <asp:ListItem Text="06" Value="06" />
                                                        <asp:ListItem Text="07" Value="07" />
                                                        <asp:ListItem Text="08" Value="08" />
                                                        <asp:ListItem Text="09" Value="09" />
                                                        <asp:ListItem Text="10" Value="10" />
                                                        <asp:ListItem Text="11" Value="11" />
                                                        <asp:ListItem Text="12" Value="12" />
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label for="<%= txtAnioVencimiento.ClientID %>">Año de vencimiento:</label>
                                                    <asp:DropDownList ID="txtAnioVencimiento" runat="server" CssClass="form-control">
                                                        <asp:ListItem Text="2024" Value="2024" />
                                                        <asp:ListItem Text="2025" Value="2025" />
                                                        <asp:ListItem Text="2026" Value="2026" />
                                                        <asp:ListItem Text="2027" Value="2027" />
                                                        <asp:ListItem Text="2028" Value="2028" />
                                                        <asp:ListItem Text="2029" Value="2029" />
                                                        <asp:ListItem Text="2030" Value="2030" />
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label for="<%= txtCVV.ClientID %>">CVV:</label>
                                                    <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" MaxLength="4" TextMode="Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvCVV" runat="server" ControlToValidate="txtCVV"
                                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="El código CVV es obligatorio"
                                                        ValidationGroup="DatosTarjeta"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="revCVV" runat="server" ControlToValidate="txtCVV"
                                                        CssClass="validation-error" Display="Dynamic" ErrorMessage="CVV inválido"
                                                        ValidationGroup="DatosTarjeta" ValidationExpression="^[0-9]{3,4}$"></asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    
                                    <!-- Panel para datos de PayPal -->
                                    <asp:Panel ID="pnlDatosPayPal" runat="server" Visible="false" CssClass="mt-4">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="alert alert-info">
                                                    <i class="bi bi-info-circle"></i> Será redirigido al sitio de PayPal para completar su pago de forma segura.
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    
                                    <div class="row mt-4">
                                        <div class="col-md-12">
                                            <asp:Button ID="btnProcesar" runat="server" Text="Procesar Compra"
                                                CssClass="btn btn-primary" OnClick="btnProcesar_Click" ValidationGroup="DatosTarjeta" />
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <!-- Paso 5: Confirmación final -->
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingConfirmacion">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseConfirmacion" aria-expanded="false" aria-controls="collapseConfirmacion">
                                        5. Confirmación de Compra
                                    </button>
                                </h2>
                                <div id="collapseConfirmacion" class="accordion-collapse collapse" aria-labelledby="headingConfirmacion" data-bs-parent="#acordeonPedido">
                                    <div class="accordion-body form-section" id="seccionConfirmacion" runat="server" visible="false">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="success-message">
                                                    <asp:Label ID="lblMensajeExito" runat="server"
                                                        Text="¡Su pedido ha sido procesado con éxito! En breve recibirá un correo con los detalles de su compra."></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row mt-3">
                                            <div class="col-md-12">
                                                <asp:Button ID="btnNuevoPedido" runat="server" Text="Realizar Nuevo Pedido"
                                                    CssClass="btn btn-primary" OnClick="btnNuevoPedido_Click" />
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <asp:ValidationSummary ID="vsGeneral" runat="server" ShowMessageBox="true" ShowSummary="false" />
                            <asp:CustomValidator ID="cvDatos" runat="server" ControlToValidate="txtCedula"
                                OnServerValidate="ValidarCedula" ErrorMessage="La cédula ingresada no es válida" Display="None"></asp:CustomValidator>
    </main>

    <!-- Aquí se mostrarán las alertas de Bootstrap dinámicamente -->
    
    <script type="text/javascript">
        function activarAcordeon(paso) {
            setTimeout(function() {
                // Cerrar todos los acordeones primero
                var acordeones = document.querySelectorAll('.accordion-collapse');
                acordeones.forEach(function(acordeon) {
                    var bsCollapse = bootstrap.Collapse.getInstance(acordeon);
                    if (bsCollapse) bsCollapse.hide();
                });
                
                // Activar el acordeón específico
                var selector = '';
                switch(paso) {
                    case 1:
                        selector = '#collapseDatosCliente';
                        break;
                    case 2:
                        selector = '#collapseProductos';
                        break;
                    case 3:
                        selector = '#collapseTotales';
                        break;
                    case 4:
                        selector = '#collapsePago';
                        break;
                    case 5:
                        selector = '#collapseConfirmacion';
                        break;
                }
                
                if (selector) {
                    var acordeon = document.querySelector(selector);
                    if (acordeon) {
                        var bsCollapse = new bootstrap.Collapse(acordeon, { toggle: true });
                    }
                }
                
                // Actualizar el indicador visual de progreso
                actualizarIndicadorProgreso(paso);
            }, 100);
        }
        
        function actualizarIndicadorProgreso(pasoActivo) {
            // Remover todas las clases de estado
            var steps = document.querySelectorAll('.step');
            steps.forEach(function(step) {
                step.classList.remove('active', 'completed');
            });
            
            // Marcar pasos completados y el paso activo
            for (let i = 1; i <= 5; i++) {
                const stepElement = document.getElementById('step' + i);
                if (stepElement) {
                    if (i < pasoActivo) {
                        stepElement.classList.add('completed');
                    } else if (i === pasoActivo) {
                        stepElement.classList.add('active');
                    }
                }
            }
        }
        
        // Función para validar que los pasos anteriores estén completos
        function validarPasosAnteriores(pasoDestino) {
            var hfPasoActivo = document.getElementById('<%= hfPasoActivo.ClientID %>');
            var pasoActual = parseInt(hfPasoActivo.value) || 1;
            
            // Solo permitir avanzar al siguiente paso o regresar a pasos anteriores
            if (pasoDestino > pasoActual + 1) {
                return false;
            }
            
            return true;
        }
        
        // Función que se ejecuta cuando el DOM está completamente cargado
        document.addEventListener("DOMContentLoaded", function () {
            const paso = document.getElementById('<%= hfPasoActivo.ClientID %>').value;
            if (paso) {
                activarAcordeon(parseInt(paso));
            }
            
            // Agregar event listeners a los botones del acordeón para validar navegación
            var botonesAcordeon = document.querySelectorAll('.accordion-button');
            botonesAcordeon.forEach(function(boton, index) {
                boton.addEventListener('click', function(e) {
                    var pasoDestino = index + 1;
                    if (!validarPasosAnteriores(pasoDestino)) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        // Mostrar mensaje de advertencia
                        var alertDiv = document.createElement('div');
                        alertDiv.className = 'alert alert-warning alert-dismissible fade show';
                        alertDiv.innerHTML = 'Debe completar los pasos anteriores antes de continuar. <button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
                        
                        var main = document.querySelector('main');
                        main.insertBefore(alertDiv, main.firstChild);
                        
                        // Auto-cerrar la alerta después de 5 segundos
                        setTimeout(function() {
                            var alert = bootstrap.Alert.getOrCreateInstance(alertDiv);
                            if (alert) alert.close();
                        }, 5000);
                    }
                });
            });
        });
    </script>
</asp:Content>
